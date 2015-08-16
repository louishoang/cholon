class AddIndicesToProductsAndProductsCategories < ActiveRecord::Migration
  def up
    add_index :products, :sku
    add_index :products_categories, [:product_id, :category_id], unique: true
  end

  def down
    remove_index :products, :sku
    remove_index :products_categories, [:product_id, :category_id]
  end
end
