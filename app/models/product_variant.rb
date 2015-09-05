class ProductVariant < ActiveRecord::Base
  belongs_to :product
  has_many :product_photos

  validates :name, presence: true
  validates :price, presence: true
  validates :product_id, presence: true
end