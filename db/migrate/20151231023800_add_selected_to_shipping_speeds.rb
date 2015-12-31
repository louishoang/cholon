class AddSelectedToShippingSpeeds < ActiveRecord::Migration
  def up
    add_column :shipping_speeds, :selected, :boolean, default: false
  end

  def down
    remove_column :shipping_speeds, :selected
  end
end
