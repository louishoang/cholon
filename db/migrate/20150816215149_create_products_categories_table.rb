class CreateProductsCategoriesTable < ActiveRecord::Migration
  def change
    create_table :products_categories do |t|
      t.integer :product_id, :null => false
      t.integer :category_id, :null => false

      t.timestamps
    end
  end
end
