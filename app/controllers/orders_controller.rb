class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def basket_info
    @order = current_order
    @order_items = @order.order_items
    @subtotal = @order.subtotal.to_f.round(2)

    respond_to do |format|
      format.json {render json: {count: @order_items.sum(:quantity), subtotal: @subtotal}}
    end
  end
end
