class AddMoreColumnsForShippingToProducts < ActiveRecord::Migration
  def up
    add_column :products, :shipping_method, :string
    add_column :products, :shipping_price, :decimal, :precision => 10, :scale => 2
    add_column :products, :location, :string
    add_column :products, :latitude, :float
    add_column :products, :longitude, :float
    add_column :products, :shipping_carrier, :string
    add_column :products, :weight, :decimal, :precision => 10, :scale => 2
    add_column :products, :length, :string
    add_column :products, :width, :string
    add_column :products, :height, :string
  end

  def down
    remove_column :products, :shipping_method
    remove_column :products, :shipping_price
    remove_column :products, :location
    remove_column :products, :latitude
    remove_column :products, :longitude
    remove_column :products, :shipping_carrier
    remove_column :products, :weight
    remove_column :products, :length
    remove_column :products, :width
    remove_column :products, :height
  end
end
