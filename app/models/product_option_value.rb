class ProductOptionValue < ActiveRecord::Base
  belongs_to :product_option
  belongs_to :product_variant

  validate_presence_of :option_id
  validate_presence_of :name
end
