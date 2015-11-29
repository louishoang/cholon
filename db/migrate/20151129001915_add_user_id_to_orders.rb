class AddUserIdToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :user_id, :integer, null: false
    add_index :orders, :user_id
  end

  def down
    remove_column :orders, :user_id
  end
end
