class AddCityAndStateToProducts < ActiveRecord::Migration
  def up
    add_column :products, :city, :string
    add_column :products, :state, :string

    add_index :products, :city
    add_index :products, :state
  end

  def down
    remove_index :products, :city
    remove_index :products, :state

    remove_column :products, :city, :string
    remove_column :products, :state, :string
  end
end
