class AddIndicesToTables < ActiveRecord::Migration
  def up
    add_index :orders, :status

  end

  def down
    remove_index :orders, :status
  end
end
