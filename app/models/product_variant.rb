class ProductVariant < ActiveRecord::Base
  belongs_to :product
  has_many :product_photos, dependent: :destroy

  has_many :variant_option_values
  has_many :product_option_values, :through => :variant_option_values

  has_many :order_items

  validates :name, presence: true
  validates :price, presence: true

  before_validation :populate_price_and_quantity, on: :create

  validates :product_id, presence: true

  scope :default_variants, -> { where(is_default: true) }
  scope :non_system_created_variants, -> { where("is_default != ?", true) }
  scope :with_photos, lambda{ |*args|
    select("DISTINCT product_variants.*")
    .joins("LEFT OUTER JOIN product_photos on product_photos.product_variant_id = product_variants.id")
    .where("product_photos.id IS NOT NULL")
  }

  def default_image
    self.product_photos.first
  end

  def is_default_variant?
    self.is_default == true
  end

  def populate_price_and_quantity
    self.price = self.product.price if self.price.blank?
    self.stock_quantity = 1 if self.stock_quantity.blank?
  end
end