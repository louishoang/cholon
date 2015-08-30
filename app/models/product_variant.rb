class ProductVariant < ActiveRecord::Base
  belongs_to :product
  mount_uploaders :photos, PhotoUploader

  validates :name, presence: true
  validates :price, presence: true
  validates :product_id, presence: true
  validates :is_default, presence: true
end