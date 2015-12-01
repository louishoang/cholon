class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @order_item = OrderItem.new(order_item_params)
    @order_item.order_id = current_order.id
    @order_item.save

    respond_to do |format|
      format.json {render json: {count: current_order.order_items.count, subtotal: current_order.subtotal}}
    end
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes(order_item_params)
    @order_items = @order.order_items
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :product_variant_id)
  end
end
