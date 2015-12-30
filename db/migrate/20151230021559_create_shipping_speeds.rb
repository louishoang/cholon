class CreateShippingSpeeds < ActiveRecord::Migration
  def change
    create_table :shipping_speeds do |t|
      t.string :name, null: false
      t.string :carrier, null: false
      t.decimal :price, :precision => 8, :scale => 2, null: false
      t.text :timeframe
      t.integer :order_item_id, null: false

      t.timestamps null: false
    end
  end
end
