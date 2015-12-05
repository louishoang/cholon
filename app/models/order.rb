class Order < ActiveRecord::Base
  enum status: { pending: 0, placed: 1, shipped: 2, cancelled: 3}

  has_many :order_items, dependent: :destroy
  before_create :set_order_status
  before_save :update_subtotal

  private
  def set_order_status
    self.status = 0
  end

  def update_subtotal
    self.subtotal = order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

end
