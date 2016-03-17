class Product < ActiveRecord::Base
  include Productable
  include Shipping
  extend FriendlyId
  friendly_id :name_utf8, use: [:slugged, :history]

  geocoded_by :location
  after_validation :geocode
  before_save :find_city_and_state

  enum condition: {:used => 1, :brand_new => 2, :refurbished => 3, :for_part_or_not_working => 4}
  enum status: {:draft => 1, :publishable => 2, :preview => 3}
  enum shipping_method: {:free_shipping => 1, :fixed_cost_shipping => 2, :actual_cost_shipping => 3}
  enum shipping_carrier: {:fedex => 1, :usps => 2, :ups => 3}
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
  validate :has_at_least_one_photo, if: lambda{self.status == Product.statuses.key(3)}

  searchable do
    text :name, :boost => 5
    text :description, :boost => 2
    integer :id, :seller_id, :stock_quantity
    string :shipping_method
    string :condition, :location, :slug, :city, :state
    double :average_seller_rating
    string :status
    double :price 
    integer :category_ids, :multiple => true
    time :created_at, :updated_at
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

  def publishable?
    self.status == Product.statuses.key(2)
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

  def create_default_variant
    if self.product_variants.blank?
      variant = ProductVariant.new()
      variant.product_id = self.id
      variant.name = self.name
      variant.price = self.price
      variant.stock_quantity = self.stock_quantity
      variant.is_default = true
      variant.save
      return variant
    else
      self.product_variants.first
    end
  end

  def variant_with_photo
    variant = self.product_variants.with_photos
  end

  def default_variant
    variant = self.product_variants.first
  end

  def name_utf8
    self.name.mb_chars.normalize(:kd).gsub(/\p{Mn}/, '').to_s.downcase.parameterize
  end

  def find_city_and_state
    if self.latitude.present? && self.longitude.present?
      address = Geocoder.search("#{self.latitude},#{self.longitude}").first
      self.city = address.city rescue nil
      self.state = address.state rescue nil
    end
  end

  def get_shipping_cost(destination_zip, quantity) #total quantity of an item
    begin
      carrier = Shipping::Carrier.new(product: self, destination_zip: destination_zip, quantity: quantity.to_i)
      all_rate_options = carrier.get_rates
    rescue
      false
    end
  end
end