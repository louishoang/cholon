class Product < ActiveRecord::Base
  CONDITION_USED = "Used"
  CONDITION_NEW = "New"
  CONDITION_REFURBISHED = "Refurbished"
  CONDITION_FOR_PART_OR_NOT_WORKING = "For Part or Not Working"

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

  def self.condition_select_option
    [[CONDITION_NEW, CONDITION_NEW],
    [CONDITION_USED, CONDITION_USED],
    [CONDITION_REFURBISHED, CONDITION_REFURBISHED],
    [CONDITION_FOR_PART_OR_NOT_WORKING, CONDITION_FOR_PART_OR_NOT_WORKING]]
  end
end