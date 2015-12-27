class ProductOptionValue < ActiveRecord::Base
  belongs_to :product_option
  belongs_to :product_variant

  validates :name, :presence => true
  validates :product_option, :presence => true
end
