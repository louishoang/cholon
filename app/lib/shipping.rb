module Shipping
  class Carrier
    attr_accessor :product, :destination, :origin, :package, :destination_zip, :order

    def initialize(args)
      @fedex_key = ENV['FEDEX_API_KEY']
      @fedex_password = ENV['FEDEX_API_PASSWORD'] #API password
      @fedex_account = ENV['FEDEX_ACCOUNT']
      @fedex_login = ENV['FEDEX_METER_NUMBER'] #meter number
      @usps_login = ENV['USPS_USERNAME']
      @test = true #NOTE: false in production and change key
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @fedex_client = new_fedex_client
      @usps_client = new_usps_client
    end

    def find_origin(product)
      origin = ActiveShipping::Location.new( :country => 'US', :state => product.state, :city => product.city, :zip => product.location)
    end

    def find_destination
      destination_coord = Geocoder.coordinates(destination_zip)
      destination = Geocoder.search(destination_coord.join(",")).first
      @destination = ActiveShipping::Location.new( :country => 'US', :state => destination.state, :city => destination.city, :zip => destination_zip)
    end

    def get_package_dimensions(product)
      package = ActiveShipping::Package.new( product.weight.to_f * 16,
        [product.length.to_f,
        product.width.to_f,
        product.height.to_f],
        :units => :imperial)
    end

    def new_fedex_client
      ActiveShipping::FedEx.new(:key => @fedex_key,
        :password => @fedex_password,
        :account => @fedex_account,
        :login => @fedex_login,
        :test => @test)
    end

    def new_usps_client
      ActiveShipping::USPS.new(
        :login => @usps_login,
        :test => @test)
    end

    def get_rate_for_one_product(product=nil)
      package = product || @product
      responses = [] ; threads = [] ; all_rate_options = []

      [@fedex_client, @usps_client].each do |client|
        threads << get_rate_using_thread_for_product(client, find_origin(package), get_package_dimensions(package), responses)
      end

      threads.each { |thr| thr.join }

      if product.present?
        responses
      else
        all_rate_options = format_response_to_rate_object(responses, all_rate_options) 
      end
    end

    def get_rate_using_thread_for_product(client, origin, package, responses)
      begin
        Thread.new do
          responses << client.find_rates(origin, @destination, package)
        end
      rescue
      end
    end

    def format_response_to_rate_object(responses, all_rate_options)
      responses.each do |response|
        response.rates.sort_by(&:price).each do |rate|
          all_rate_options << {:carrier => rate.carrier,
            :name => rate.service_name,
            :price => rate.price.to_f * @quantity,
            :timeframe => rate.delivery_range}
        end
      end
      all_rate_options
    end

    def get_rate_for_whole_order
      # Thread.abort_on_exception = true        #debugger mode
      threads = [] ; errors = []

      order_items = OrderItem.joins(:order, product_variant: :product)
        .where("orders.order_number = ? AND products.shipping_method = ?",
          @order.id, Product.shipping_methods[:actual_cost_shipping]) rescue nil

      if order_items.present?
        order_items.each_with_index do |item, index|
          begin
            next if item.selected_shipping_speed.present?
            product = item.product_variant.product
            origin = find_origin(product)
            package = get_package_dimensions(product)

            responses = get_rate_for_one_product(product)
            save_rates_to_shipping_speed(item, responses)
          ensure
            item.save
          end
        end
        threads.each { |thr| thr.join }
      end
    end

    def delete_old_rates(item)
      if item.shipping_speeds.present?
        item.shipping_speeds.destroy_all
      end
    end

    def save_rates_to_shipping_speed(item, responses)
      delete_old_rates(item)
      responses.each do |response|
        response.rates.sort_by(&:price).each_with_index do |_option, _i|
          selected = _i == 0 ? true : false
          item.shipping_speeds << ShippingSpeed.new(carrier: _option.carrier,
          name: _option.service_name, price: _option.total_price * item.quantity,
          timeframe: _option.delivery_range, selected: selected)
        end
      end
    end

    def get_rates
      find_destination
      if @product.present?
        get_rate_for_one_product
      elsif @order.present?
        get_rate_for_whole_order
      end
    end
  end
end