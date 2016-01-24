module ProductHelper
  def current_min_price
    price = params[:min_price] || @min_price
  end

  def current_max_price
    price = params[:max_price] || @max_price
  end

  def merge_params(params=nil, new_attr)
    if params.present?
      "#{params},#{new_attr}"
    else
      new_attr
    end
  end

  def current_category_facet(search_resp)
    search_resp.facet(:category_ids).rows.map{|x| [x.value, x.count]} rescue nil
  end

  def current_condition_facet(search_resp)
    search_resp.facet(:condition).rows.map{|x| [x.value, x.count]} rescue nil
  end

  def current_shipping_method_facet(search_resp)
    search_resp.facet(:shipping_method).rows.map{|x| [x.value, x.count]} rescue nil
  end
end