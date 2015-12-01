class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
    existed = check_if_item_exist_in_order(params)
      if existed != true
        save_new_item_to_order(params)
      end
    rescue => e
      respond_to do |format|
        format.json {render json: e.messages, status: :unprocessable_entity}
      end
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

  def save_new_item_to_order(params)
    @order_item = OrderItem.new(order_item_params)
    @order_item.order_id = current_order.id
    @order_item.save

    json_success_respond
  end

  def check_if_item_exist_in_order(params)
    existed = false
    item = current_order.order_items.find_by_product_variant_id("5") rescue nil
    if item.present?
      item.quantity += params[:order_item][:quantity].to_i
      item.save
      existed = true
      json_success_respond
    end
    existed
  end

  def json_success_respond
    respond_to do |format|
      format.json {render json: {count: current_order.order_items.count, subtotal: current_order.subtotal}}
    end
  end
end
