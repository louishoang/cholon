class ProductOption < ActiveRecord::Base
  has_many :product_option_values
  validate_presence_of :name
end
