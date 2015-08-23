class Product < ActiveRecord::Base
  has_many :product_categories
  has_many :categories, through: :product_categories
  belongs_to :user
  has_many :product_variants, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { in: 8..80 }
  validates :short_description, length: {maximum: 200}
  validates :price, presence: true
  validates :stock_quantity, presence: true
  validates :user_id, presence: true


end