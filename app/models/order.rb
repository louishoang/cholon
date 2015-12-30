class Order < ActiveRecord::Base
  enum status: { pending: 0, placed: 1, shipped: 2, cancelled: 3}

  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
  before_create :set_order_status
  before_save :update_total

  def calculate_shipping_price(destination_zip)
    fedex = ShippingCalculator::Fedex.new(order: self, destination_zip: destination_zip)
    response = fedex.get_rates
  end

  private
  def set_order_status
    self.status = 0
  end

  def update_subtotal
    self.subtotal = order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def update_shipping_price
    self.shipping_price = 0
    order_items.each do |item|
      if item.shipping_speed.present?
        self.shipping_price += item.shipping_speed.price.to_f / 100
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
