module ShippingCalculator
  class Fedex
    attr_accessor :product, :destination, :origin, :package, :destination_zip, :order

    def initialize(args)
      @key = ENV['FEDEX_API_KEY']
      @password = ENV['FEDEX_API_PASSWORD'] #API password
      @account = ENV['FEDEX_ACCOUNT']
      @login = ENV['FEDEX_METER_NUMBER'] #meter number
      @test = true #NOTE: false in production and change key
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @client = new_client
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

    def new_client
      ActiveShipping::FedEx.new(:key => @key,
        :password => @password,
        :account => @account,
        :login => @login,
        :test => @test)
    end

    def get_rate_for_one_product
      origin = find_origin(@product)
      package = get_package_dimensions(@product)
      response = @client.find_rates(origin, @destination, package)
      all_rate_options = []
      all_rate_options += response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price.to_f * @quantity]}
    end

    def get_rate_using_thread(item)
      Thread.new do
        product = item.product_variant.product
        origin = find_origin(product)
        package = get_package_dimensions(product)
        response = @client.find_rates(origin, @destination, package)

        lowest_price_option = response.rates.sort_by(&:price).first
        item.shipping_speed.destroy if item.shipping_speed.present?
        item.shipping_speed = ShippingSpeed.new(carrier: lowest_price_option.carrier,
          name: lowest_price_option.service_name, price: lowest_price_option.total_price * item.quantity,
          timeframe: lowest_price_option.delivery_range)
        item.save
      end
    end

    def get_rate_for_whole_order
      # Thread.abort_on_exception = true        #debugger mode
      threads = [] ; errors = []

      order_items = OrderItem.joins(:order, product_variant: :product)
        .where("orders.id = ? AND products.shipping_method = ?",
          @order.id, Product.shipping_methods[:actual_cost_shipping]) rescue nil

      if order_items.present?
        order_items.each_with_index do |item, index|
          begin
            threads << get_rate_using_thread(item)
          rescue => e
            #TODO : when having time, should try to recall to update shipping price correctly
            errors << e.message
          end
        end
        threads.each { |thr| thr.join }
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