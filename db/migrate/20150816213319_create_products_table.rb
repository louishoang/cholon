class CreateProductsTable < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, :precision => 10, :scale => 2
      t.string :sku
      t.integer :stock_quantity
      t.integer :seller_id
      t.string :condition
      t.string :location
      t.string :slug

      t.timestamps
    end
  end
end
