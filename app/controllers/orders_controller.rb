class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
    @order = current_order
    @order_items = @order.order_items.includes(product_variant: :product).group_by(&:seller_id)
    begin
      @order.calculate_shipping_price(session[:current_user_zip_code]) if @order_items.present?
    rescue
    end
    @order.save #calling save to update total, shiping price
  end

  def basket_info
    @order = current_order
    @order_items = @order.order_items
    @subtotal = view_context.number_to_currency(@order.subtotal)

    respond_to do |format|
      format.json {render json: {count: @order_items.sum(:quantity), subtotal: @subtotal}}
    end
  end

  def update
    if current_order.update_attributes(order_params)
      if params[:checkout].present?
        render js: "window.location='#{checkout_order_path(current_order)}'"
      else
        render js: "window.location='#{order_path(current_order)}'"
      end
    else
      respond_to do |f|
        f.json {render json: current_order.message, status: :unprocessable_entity}
      end
    end
  end

  def checkout
    @order = current_order
  end

  def destroy
  end

  private
  def order_params
    params.require(:order).permit(:id, :subtotal, :tax, :total, :status, :shipping_price, :user_id,
    order_items_attributes: [:id, :quantity, :product_id, :order_id, :unit_price, :total_price,
      :seller_id, :product_variant_id])
  end
end
