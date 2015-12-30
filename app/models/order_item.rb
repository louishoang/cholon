class OrderItem < ActiveRecord::Base
  belongs_to :product_variant
  belongs_to :order
  has_one :shipping_speed

  validates :quantity, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates_presence_of :product_variant_id
  validates_presence_of :order_id

  before_validation :update_product_id_unit_price_total_price

  def update_product_id_unit_price_total_price
    if self.product_variant_id.present?
      self.product_id = self.product_variant.product_id
      self.unit_price = self.product_variant.price
      self.total_price = self.unit_price * self.quantity
      self.seller_id = self.product_variant.product.seller_id
    end
  end

  def first_availble_photo
    photo = self.product_variant.default_image.photo(:medium) rescue nil
    if photo.blank?
      photo = self.product_variant.product.variant_with_photo.first.default_image.photo(:medium) rescue nil
    end
    photo
  end
end
