class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
    @order = current_order
    @order_items = @order.order_items.includes(:product_variant).group_by(&:seller_id)
  end

  def basket_info
    @order = current_order
    @order_items = @order.order_items
    @subtotal = view_context.number_to_currency(@order.subtotal)

    respond_to do |format|
      format.json {render json: {count: @order_items.sum(:quantity), subtotal: @subtotal}}
    end
  end
end
