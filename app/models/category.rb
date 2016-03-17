class Category < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :parent_category, :class_name => "Category", :foreign_key => "parent_id" 
  has_many :childrens, :class_name => "Category", :foreign_key => "parent_id"

  has_many :product_categories, :dependent => :destroy
  has_many :products, :through => :product_categories

  scope :main_category, -> {where("parent_id IS NULL")}
  scope :children_category, -> {where("parent_id IS NOT NULL")}

  def self.category_for_index_panel
    Category.main_category.where("id NOT IN (?)", [4, 14, 22, 25, 29, 30, 48])
  end

  def all_sub_categories
    categories = []
    self.childrens.each do |child|
      categories << child
      categories << child.childrens if child.childrens.present?
    end
    categories.flatten
  end
end