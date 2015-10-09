class ProductVariant < ActiveRecord::Base
  belongs_to :product
  has_many :product_photos, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true
  validates :product_id, presence: true

  scope :default_variants, -> { where(is_default: true) }

  def default_image
    self.product_photos.first
  end
end