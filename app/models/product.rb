class Product < ActiveRecord::Base
  geocoded_by :location
  after_validation :geocode
  before_save :get_city_and_state

  extend FriendlyId
  friendly_id :name_utf8, use: [:slugged, :history]

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

  scope :join_all, lambda{ |*args|
    select("DISTINCT products.*")
    .joins("LEFT OUTER JOIN product_variants ON products.id = product_variants.product_id")
    .joins("LEFT OUTER JOIN product_categories ON products.id = product_categories.product_id")
    .joins("LEFT OUTER JOIN categories ON product_categories.category_id = categories.id")
  }


  scope :publishable, -> { where(status: Product.statuses[:publishable]) }

  scope :with_categories, lambda{ |*args|
    if args.present? && args[0].present?
      category_ids = args[0].split(",")
      where("categories.id IN (?)", category_ids)
    end
  } 

  scope :with_category, lambda{ |args|
    if args.present?
      where("categories.id = ?", args)
    end
  } 

  scope :with_condition, lambda{ |args|
    if args.present?
      where("products.condition = ?", args)
    end
  }

  scope :price_between, lambda { |args|
    if args.present? && args.is_a?(Array) && args[0].present?
      lowest_price = args[0]
      highest_price = args[1]
      if lowest_price.to_f == highest_price.to_f
        highest_price = highest_price.to_f + 1
      end
      where("products.price BETWEEN ? AND ?", lowest_price, highest_price)
    end
  }

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

  def get_city_and_state
    if self.latitude.present? && self.longitude.present?
      address = Geocoder.search("#{self.latitude},#{self.longitude}").first
      self.city = address.city rescue nil
      self.state = address.state rescue nil
    end
  end

  def get_shipping_cost(destination_zip, sh_quantity) #total quantity of an item
    begin
      sh_quantity = sh_quantity.to_i
      all_rate_options = []

      destination_coord = Geocoder.coordinates(destination_zip)
      destination = Geocoder.search(destination_coord.join(",")).first

      origin = ActiveShipping::Location.new( :country => 'US', :state => self.state, :city => self.city, :zip => self.location)

      destination = ActiveShipping::Location.new( :country => 'US', :state => destination.state, :city => destination.city, :zip => destination_zip)

      package = ActiveShipping::Package.new( self.weight.to_f * 16 * sh_quantity, [self.length.to_f * sh_quantity, self.width.to_f * sh_quantity, self.height.to_f * sh_quantity], :units => :imperial)
      
      fedex = ActiveShipping::FedEx.new(:key => ENV['FEDEX_API_KEY'], #developer API key
        :password => ENV['FEDEX_API_PASSWORD'], #API password
        :account => ENV['FEDEX_ACCOUNT'],
        :login => ENV['FEDEX_METER_NUMBER'], #meter number
        :test => true) #NOTE: false in production and change key

      response = fedex.find_rates(origin, destination, package)

      # find rate USPS
      all_rate_options += response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      all_rate_options
    rescue
      false
    end
  end
end