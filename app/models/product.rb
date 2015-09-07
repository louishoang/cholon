class Product < ActiveRecord::Base
  CONDITION_USED = "Used"
  CONDITION_NEW = "New"
  CONDITION_REFURBISHED = "Refurbished"
  CONDITION_FOR_PART_OR_NOT_WORKING = "For Part or Not Working"

  has_many :product_categories
  has_many :categories, through: :product_categories
  belongs_to :user
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  validates :name, presence: true
  validates :name, length: { in: 8..80 }
  validates :short_description, length: {maximum: 200}
  validates :price, presence: true
  validates :stock_quantity, presence: true
  validates :user_id, presence: true

  scope :join_all, lambda{ |*args|
    select("DISTINCT products.*")
    .joins("LEFT OUTER JOIN product_variants ON products.id = product_variants.product_id")
    .joins("LEFT OUTER JOIN product_categories ON products.id = product_categories.product_id")
    .joins("LEFT OUTER JOIN categories ON product_categories.category_id = categories.id")
  }

  def self.condition_select_option
    [[CONDITION_NEW, CONDITION_NEW],
    [CONDITION_USED, CONDITION_USED],
    [CONDITION_REFURBISHED, CONDITION_REFURBISHED],
    [CONDITION_FOR_PART_OR_NOT_WORKING, CONDITION_FOR_PART_OR_NOT_WORKING]]
  end

  def self.condition_array
    [CONDITION_NEW, CONDITION_USED, CONDITION_REFURBISHED, CONDITION_FOR_PART_OR_NOT_WORKING]
  end

  def create_default_variant
    if self.product_variants.blank?
      variant = ProductVariant.new()
      variant.product_id = self.id
      variant.is_default = true
      variant.name = self.name
      variant.price = self.price
      variant.stock_quantity = self.stock_quantity
      variant.save
      return variant
    end
  end

  def default_variant
    variant = self.product_variants.default_variant rescue nil
    if variant.blank?
      variant = self.product_variants.first
    end
    variant
  end
end