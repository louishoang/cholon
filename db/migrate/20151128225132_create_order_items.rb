class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :product_id, null: false
      t.string :order_number, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.integer :quantity
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps null: false
      t.index [:product_id, :order_number], unique: true
    end
  end
end
