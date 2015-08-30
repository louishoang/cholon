class AddIndicesToProductsAndProductCategories < ActiveRecord::Migration
  def up
    add_index :products, :sku
    add_index :product_categories, [:product_id, :category_id], unique: true
  end

  def down
    remove_index :products, :sku
    remove_index :product_categories, [:product_id, :category_id]
  end
end
