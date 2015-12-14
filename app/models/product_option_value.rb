class ProductOptionValue < ActiveRecord::Base
  belongs_to :product_option
  belongs_to :product_variant

  validates :product_option, :presence => true
  validates :name, :presence => true
end
