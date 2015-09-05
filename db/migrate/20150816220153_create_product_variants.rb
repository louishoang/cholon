class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
      t.integer :product_id, null: false
      t.boolean :is_default
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.string :sku
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
