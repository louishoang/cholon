class Category < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id" 
  has_many :childrens, :class_name => "Category", :foreign_key => "parent_id"

  has_many :product_categories, :dependent => :destroy
  has_many :products, :through => :product_categories

  scope :main_category, -> {where("parent_id IS NULL")}
  scope :children_category, -> {where("parent_id IS NOT NULL")}
end