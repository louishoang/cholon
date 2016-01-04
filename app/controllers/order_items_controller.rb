class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      unless item_exist_in_order(params)
        save_new_item_to_order(params)
      end
    rescue => e
      respond_to do |format|
        format.json {render json: e.message, status: :unprocessable_entity}
      end
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])
    if @order_item.update_attributes(order_item_params)
      render js: "window.location='#{order_path(@order_item.order)}'"
    else
      respond_to do |f|
        f.json {render json: @order_item.message, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    if @order_item.destroy
      render js: "window.location='#{order_path(@order_item.order)}'"
    else
      respond_to do |f|
        f.json {render json: @order_item.message, status: :unprocessable_entity}
      end
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :product_variant_id)
  end

  def save_new_item_to_order(params)
    @order_item = OrderItem.new(order_item_params)
    @order_item.order_number = current_order.order_number
    @order_item.save

    json_success_respond
  end

  def item_exist_in_order(params)
    existed = false
    item = current_order.order_items.find_by_product_variant_id(params[:order_item][:product_variant_id]) rescue nil
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
