class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, id: false do |t|
      t.string :order_number, null: false
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :orders, :order_number, unique: true
  end
end
