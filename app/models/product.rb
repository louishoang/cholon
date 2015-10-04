class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name_utf8, use: [:slugged, :history]

  CONDITION_USED = "Used"
  CONDITION_NEW = "New"
  CONDITION_REFURBISHED = "Refurbished"
  CONDITION_FOR_PART_OR_NOT_WORKING = "For Part or Not Working"

  STATUS_DRAFT = "Draft"
  STATUS_PUBLISHABLE = "Publishable"

  SHIPPING_METHOD_FREE = "Free Shipping"
  SHIPPING_METHOD_FIXED_COST = "Fixed Cost Shipping"
  SHIPPING_METHOD_ACTUAL_COST = "Actual Cost Shipping"

  SHIPPING_CARRIER_FEDEX = "FedEx"
  SHIPPING_CARRIER_USPS = "USPS"
  # SHIPPING_CARRIER_UPS = "UPS" 
  # NOTE: need to work with ups after website's done to get key

  has_many :product_categories
  has_many :categories, through: :product_categories
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  validates :name, presence: true
  validates :name, length: { in: 8..80 }
  validates :condition, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
  validates :seller_id, presence: true
  validate :has_at_least_one_photo, if: :status_publishable

  scope :join_all, lambda{ |*args|
    select("DISTINCT products.*")
    .joins("LEFT OUTER JOIN product_variants ON products.id = product_variants.product_id")
    .joins("LEFT OUTER JOIN product_categories ON products.id = product_categories.product_id")
    .joins("LEFT OUTER JOIN categories ON product_categories.category_id = categories.id")
  }

  scope :publishable, -> { where(status: STATUS_PUBLISHABLE) } 

  def status_publishable
    self.status == STATUS_PUBLISHABLE
  end

  def all_photos
    to_return = []
    self.product_variants.each do |variant|
      variant.product_photos.each do |pp|
        to_return << pp
      end
    end
    to_return.flatten
  end

  def has_at_least_one_photo
    return_str = false
    self.product_variants.each do |variant|
      if variant.product_photos.present?
        return_str = true
        return return_str
      end
    end
    if return_str == false
      errors[:base] << "Product needs at least one photo"
    end
  end

  def self.shipping_method_option
    [ 
      [SHIPPING_METHOD_ACTUAL_COST, SHIPPING_METHOD_ACTUAL_COST],
      [SHIPPING_METHOD_FIXED_COST, SHIPPING_METHOD_FIXED_COST],
      [SHIPPING_METHOD_FREE, SHIPPING_METHOD_FREE]
    ]
  end

  def self.shipping_carrier_array
    #NOTE: need to add ups when it's available
    [SHIPPING_CARRIER_FEDEX, SHIPPING_CARRIER_USPS]
  end

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
      variant.name = self.name
      variant.price = self.price
      variant.stock_quantity = self.stock_quantity
      variant.save
      return variant
    else
      self.product_variants.first
    end
  end

  def default_variant
    variant = self.product_variants.first
  end

  def name_utf8
    self.name.mb_chars.normalize(:kd).gsub(/\p{Mn}/, '').to_s.downcase.parameterize
  end
end