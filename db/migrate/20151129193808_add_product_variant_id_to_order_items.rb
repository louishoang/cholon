class AddProductVariantIdToOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :product_variant_id, :integer, null: false unless column_exists?(:order_items, :product_variant_id)
    add_index :order_items, [:product_variant_id, :order_number], unique: true unless index_exists?(:order_items, [:product_variant_id, :order_number])
    add_index :order_items, :product_id
  end

  def down
    remove_index :order_items, :product_id
    remove_index :order_items, [:product_variant_id, :order_number]
    remove_column :order_items, :product_variant_id
  end
end
