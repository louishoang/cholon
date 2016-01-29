module ProductHelper
  def current_min_price
    price = params[:min_price] || @min_price
  end

  def current_max_price
    price = params[:max_price] || @max_price
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

  def merge_params_if_existed(params, ptype, value)
    list = params[ptype].split(",") rescue nil
    if list.blank?
      url_for(params.merge({:category => value.to_s}))
    elsif list.present? && !list.include?(value.to_s)
      list << value.to_s
      url_for(params.merge({:category => list.join(",")}))
    else
      url_for(params)
    end
  end

  def dhskhfdskjf_params(params, ptype, value)
    list = params[ptype].split(",") rescue nil
    if list.present? && list.size == 1
      url_for(params.except(ptype))
    elsif list.present?
      _list = list; _params = params.clone #prevent direct params change
      _list.delete(value.to_s)
      _params[ptype] = _list.join(",")
      url_for(_params)
    end
  end
end