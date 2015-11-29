class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def basket_info
    @order = current_order
    @order_items = @order.order_items

    respond_to do |format|
      format.json {render json: {count: @order_items.count}}
    end
  end
end
