class AddStatusToProducts < ActiveRecord::Migration
  def up
    add_column :products, :status, :integer
  end

  def down
    remove_column :products, :status
  end
end
