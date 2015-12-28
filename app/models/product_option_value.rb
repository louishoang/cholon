class ProductOptionValue < ActiveRecord::Base
  belongs_to :product_option

  has_many :variant_option_values
  has_many :product_variants, :through => :variant_option_values

  validates :name, :presence => true
  validates :product_option, :presence => true
end
