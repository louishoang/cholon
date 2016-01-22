module Workers::ProductWorker
  def query_products(params)
    slave = params[:sort_by] ? "Product_by_#{params[:sort_by]}" : nil

    queries = { hitsPerPage: 48, page: params[:page].to_i, facets: '*',
      facetFilters: [
        "condition: #{params[:condition]}",
        "shipping_method: #{params[:shipping_method]}"
      ],
      numericFilters: [
        "price:#{params[:min_price] || 0} to #{params[:max_price] || 999999999999999}"
      ],
      slave: slave
    }

    latLng, radius = geocode_lat_long(params)

    if latLng.present?
      queries[:aroundLatLng] = latLng
      queries[:aroundRadius] = radius
    end

    if params[:category].present?
      queries[:facetFilters] << "category_ids:#{params[:category]}"
    end

    response = Product.raw_search(params[:query], queries)


    products = Kaminari.paginate_array(response["hits"]).page(response["page"]).per(48)
    [response, products]
  end

  def geocode_lat_long(params)
    latLng = nil; radius =
    if params[:zip_code].present?
      loc = Geocoder.search(params[:zip_code]).first.data["geometry"]["location"]
      latLng = [loc["lat"], loc["lng"]].join(",")
      radius = params[:radius].to_i * 1609
    end
    [latLng, radius]
  end
end