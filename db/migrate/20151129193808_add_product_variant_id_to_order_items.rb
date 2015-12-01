class AddProductVariantIdToOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :product_variant_id, :integer, null: false unless column_exists?(:order_items, :product_variant_id)
    add_index :order_items, [:product_variant_id, :order_id], unique: true unless index_exists?(:order_items, [:product_variant_id, :order_id])
    add_index :order_items, :product_id
  end

  def down
    remove_index :order_items, :product_id
    remove_index :order_items, [:product_variant_id, :order_id]
    remove_column :order_items, :product_variant_id
  end
end
