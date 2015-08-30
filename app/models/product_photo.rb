class ProductPhoto < ActiveRecord::Base
  belongs_to :product_variant
  mount_uploaders :photos, PhotoUploader
end