class Category < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id" 
  has_many :childrens, :class => "Category", :foreign_key => "parent_id"

  has_many :products_categories, :dependent => :destroy
  has_many :products, :through => :products_categories
end