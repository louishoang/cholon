class AddStatusToProducts < ActiveRecord::Migration
  def up
    add_column :products, :status, :string
  end

  def down
    remove_column :products, :status
  end
end
