class AddSellerIdToOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :seller_id, :integer, null: false
    add_index :order_items, :seller_id
  end

  def down
    remove_column :order_items, :seller_id
  end
end
