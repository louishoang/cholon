class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates_presence_of :product_id
  validates_presence_of :order_id

  before_save: update_total_price

  def unit_price
    if persisted?
      self.unit_price
    else
      self.product.price
    end
  end

  def update_total_price
    self.total_price = self.unit_price * self.quantity
  end
end
