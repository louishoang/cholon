module ApplicationHelper
	def current_locale
		I18n.locale
	end

	def current_language
		if current_locale == :en
			"English"
		else
			"Tiếng Việt"
		end
	end

  def current_order
    return @current_order if @current_order.present?
    return nil if current_user.blank?
    @current_order = Order.find_or_create_by(:user_id => current_user.id, status: Order.statuses[:pending])
  end

  def current_items
    @current_items ||= current_order.order_items
  end

  def current_subtotal
    @current_subtotal ||= current_items.sum(:total_price)
  end

  def timeframe_to_string(timeframe)
    timeframe.uniq.map{|x| x.to_s(:month_date_shipping)}.join("-") rescue "Unknown"
  end

  def price_filter_string(params)
    "#{number_to_currency(params[:min_price])} - #{number_to_currency(params[:max_price])}"
  end

  def current_sort_by_text
    to_return = case params[:sort_by]
    when 'price_asc'
      t"Price: Lowest first"
    when 'price_desc'
      t"Price: Highest first"
    when 'created_at_desc'
      t"Newest"
    else
      t"Best Match"
    end
    to_return
  end

  def any_filter_or_search?(params)
    [:query, :min_price, :max_price, :shipping, :category, :condition].each do |_filter|
      return true if params[_filter].present?
    end
    false
  end
end
