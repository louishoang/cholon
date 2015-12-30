class AddShippingPriceToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :shipping_price, :decimal, :precision => 8, :scale => 2
  end

  def down
    remove_column :orders, :shipping_price
  end
end
