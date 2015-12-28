class VariantOptionValue < ActiveRecord::Base
  belongs_to :product_variant
  belongs_to :product_option_value

  validates :product_variant, :presence => true
  validates :product_option_value, :presence => true
end