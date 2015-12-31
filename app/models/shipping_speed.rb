class ShippingSpeed < ActiveRecord::Base
  after_save :ensure_only_one_is_selected

  validates :name, :presence => true
  validates :price, :presence => true
  validates :carrier, :presence => true
  validates :order_item, :presence => true

  belongs_to :order_item

  serialize :timeframe

  scope :is_selected, -> { where(selected: true) } 

  private
  def ensure_only_one_is_selected
    self.order_item.shipping_speeds.where("id != #{self.id}").update_all(:selected => false)
  end
end
