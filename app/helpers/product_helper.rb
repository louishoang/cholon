module ProductHelper
  def current_min_price
    price = params[:min_price] || @min_price
  end

  def current_max_price
    price = params[:max_price] || @max_price
  end
end