class AddBrandToProducts < ActiveRecord::Migration
  def up
    add_column :products, :brand, :string
    add_index :products, :brand
  end

  def down
    remove_index :products, :brand
    remove_column :products, :brand
  end
end
