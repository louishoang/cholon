class Order < ActiveRecord::Base
  include Merchant

  enum status: { pending: 0, placed: 1, shipped: 2, cancelled: 3, declined: 4}

  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true

  #dependent destroy will allow order.update_attributes to delete old record and create new one
  has_one :shipping_address, class_name: "Address", foreign_type: "ShippingAddress", :dependent => :destroy
  has_one :billing_address, class_name: "Address", foreign_type: "BillingAddress", :dependent => :destroy
  accepts_nested_attributes_for :shipping_address, allow_destroy: true
  accepts_nested_attributes_for :billing_address, allow_destroy: true

  before_create :set_order_status
  before_save :update_total

  def calculate_shipping_price(destination_zip)
    fedex = ShippingCalculator::Fedex.new(order: self, destination_zip: destination_zip)
    response = fedex.get_rates
  end

  def apply_shipping_speed(shipping_speed)
    @shipping_speeds = ShippingSpeed.joins(order_item: :order)
      .where("orders.id = #{self.id}")
      .update_all(:selected => true)
  end

  def charge!(nonce_from_client)
    pos = Merchant::POS.new(nonce_from_the_client: nonce_from_client,
      order: self, current_user: User.find(self.user_id))
    pos.charge
  end

  private
  def set_order_status
    self.status = Order.statuses[:pending]
  end

  def update_subtotal
    self.subtotal = order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def update_shipping_price
    self.shipping_price = 0
    order_items.each do |item|
      if item.shipping_speeds.present?
        self.shipping_price += item.selected_shipping_speed.price.to_f / 100
      else
        product = Product.find(item.product_id) rescue nil
        self.shipping_price += product.shipping_price if product.shipping_price
      end
    end
  end

  def update_total
    update_subtotal
    update_shipping_price
    self.total = self.subtotal + self.shipping_price
  end
end
