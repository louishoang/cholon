class ShippingSpeedsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_shipping_speed, :only => [:edit]

  def edit
    @order_item = @shipping_speed.order_item rescue nil
    render :partial => "edit"
  end

  def update
    @shipping_speed = ShippingSpeed.find(params[:shipping_speed])
    @shipping_speed.selected = true
    @shipping_speed.save

    render js: "window.location='#{order_path(current_order)}'"
  end

  private
  def find_shipping_speed
    @shipping_speed = ShippingSpeed.find(params[:id])
  end
end
