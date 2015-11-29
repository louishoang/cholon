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

	 # set order to session
  def current_order
    return @current_order if @current_order.present?
    @current_order = nil
    if !session[:order_id].nil?
      @current_order = Order.find(session[:order_id])
    else
      # find last pending order or create new one
      @current_order = Order.find_or_create_by(:user_id => current_user.id, status: 0)
    end
    @current_order
  end

  def current_items
    @current_items ||= current_order.order_items
  end

  def current_subtotal
    @current_subtotal ||= current_items.sum(:total_price)
  end
end
