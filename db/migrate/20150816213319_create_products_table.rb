class CreateProductsTable < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :short_description
      t.text :description
      t.decimal :price, :precision => 10, :scale => 2
      t.string :sku
      t.integer :stock_quantity
      t.integer :user_id
      t.string :condition
      t.text :note
      t.string :location

      t.timestamps
    end
  end
end
