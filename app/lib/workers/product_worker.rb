module Workers::ProductWorker
  include ProductHelper
  def query_products(params)
    sort_by, order = produce_sort_by(params) if params[:sort_by]
    lat, lng, radius = geocode_lat_long(params) if params[:radius].present? && params[:zip_code].present?
    seller_rating_range = combine_seller_rating_range(params)[0]..combine_seller_rating_range(params)[1] if params[:rating].present? 

    response = Product.search do 
      fulltext params[:query] do
        phrase_fields :name => 3.0  #match any word in query, score 3x higher if the word appear in title
        phrase_slop   1 #with one word between them
      end
      with(:category_ids, params[:category].split(",")) if params[:category].present?
      with(:condition, params[:condition].split(",")) if params[:condition].present?
      with(:shipping_method, params[:shipping].split(",")) if params[:shipping].present?
      with(:brand, params[:brands].split(",")) if params[:brands].present?
      if params[:rating].present?
        with(:average_seller_rating, seller_rating_range)
      end
      with(:status, "publishable")
      if params[:min_price].present?
        all_of do
          with(:price).greater_than_or_equal_to(params[:min_price])
          with(:price).less_than_or_equal_to(params[:max_price])
        end
      end
      facet :condition, :category_ids, :shipping_method, :price, :average_seller_rating
      order_by sort_by, order if params[:sort_by]
      with(:location).in_radius(lat, lng, radius) if params[:radius].present? && params[:zip_code].present?
      paginate :page => params[:page], :per_page => params[:per_page]
    end
    products = response.results
    [response, products]
  end

  def geocode_lat_long(params)
    lat = nil; lng = nil; radius = nil
    if params[:zip_code].present?
      loc = Geocoder.search(params[:zip_code]).first.data["geometry"]["location"]
      lat = loc["lat"]
      lng = loc["lng"]
      radius = params[:radius].to_i * 1.609
    end
    [lat, lng, radius]
  end

  def produce_sort_by(params)
    order = params[:sort_by].match(/(asc|desc)/)[1]
    sort_by = params[:sort_by].gsub(/_(asc|desc)/, "")
    [sort_by.to_sym, order.to_sym]
  end

  def product_price_min_max
    @min_price = Product.minimum("price").to_f
    @max_price = Product.maximum("price").to_f
    @max_price += 1 if @min_price == @max_price
  end

  def refresh_search_result?
    params[:refresh].present? && params[:refresh] == "true"
  end
end