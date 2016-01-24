module Workers::ProductWorker
  def query_products(params)
    sort_by, order = produce_sort_by(params) if params[:sort_by]
    lat, lng, radius = geocode_lat_long(params) if params[:radius].present? && params[:zip_code].present?

    response = Product.search do 
      fulltext params[:query] do
        phrase_fields :name => 2.0
        query_phrase_slop 3
      end
      with(:category_ids, params[:category]) if params[:category].present?
      facet :condition, :category_ids, :shipping_method
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
end