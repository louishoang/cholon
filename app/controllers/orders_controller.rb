class OrdersController < ApplicationController
  before_action :authenticate_user!

  def show
    @order = current_order
    @order_items = @order.order_items.includes(product_variant: :product).group_by(&:seller_id)
    begin
      @order.calculate_shipping_price(session[:current_user_zip_code]) if @order_items.present?
    rescue
      flash[:alert] = "Shipping carriers' servers are responding slow. Shipping rates are estimated only."
    end
    @order.save #calling save to update total & shipping price
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
      if params[:checkout].present? && params[:update_button].blank?
        render js: "window.location='#{checkout_order_path(current_order)}'"
      else
        render js: "window.location='#{order_path(current_order)}'"
      end
    else
      respond_to do |f|
        f.json {render json: {:message => current_order.errors.full_messages.to_sentence}, status: :unprocessable_entity }
      end
    end
  end

  def checkout
    @order = current_order
    @order.build_shipping_address
    @order.build_billing_address
    @client_token = Braintree::ClientToken.generate
  end

  def result
    if request.post?
      @order = current_order
      handle_billing_to_shipping unless params[:billing_shipping_same]
      begin 
        @order.update_attributes(order_params)
        result = @order.charge!(params[:payment_method_nonce])
        if result == true
          respond_to do |format|
            format.json{ render json: {:location => result_order_path(:order_status => :success) }}
          end
        else
          raise result
        end
      rescue => e
        respond_to do |format|
          format.json {render json: e.message rescue e }
        end
      end
    else
       @order = Order.find(params[:order_number])
       @shipping_address = @order.shipping_address
    end
  end

  def destroy
  end

  private
  def order_params
    params.require(:order).permit(:id, :subtotal, :tax, :total, :status, :shipping_price, :user_id,
    order_items_attributes: [:id, :quantity, :product_id, :order_number, :unit_price, :total_price,
      :seller_id, :product_variant_id],
    billing_address_attributes: [:first_name, :last_name, :business_name, :address1, :address2, :city, :state, :zip_code],
    shipping_address_attributes: [:first_name, :last_name, :business_name, :address1, :address2, :city, :state, :zip_code])
  end

  def handle_billing_to_shipping
    params[:order][:shipping_address_attributes] = params[:order][:billing_address_attributes]
    params
  end
end
