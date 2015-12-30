class ShippingSpeed < ActiveRecord::Base
  validates :name, :presence => true
  validates :price, :presence => true
  validates :carrier, :presence => true
  validates :order_item, :presence => true

  belongs_to :order_item

  serialize :timeframe
end
