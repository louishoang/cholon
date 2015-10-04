class AddDefaultToProductVariantsAndIndicesOnMultipleColumns < ActiveRecord::Migration
  def up
    # product variants table
    add_column :product_variants, :is_default, :boolean, default: false
    add_index :product_variants, :is_default
    add_index :product_variants, :product_id
    add_index :product_variants, :sku

    #categories table
    add_index :categories, :parent_id

    #product_photos table
    add_index :product_photos, :product_variant_id

    # products
    add_index :products, :shipping_carrier
    add_index :products, :status
    add_index :products, :condition
  end

  def down
    # product variants table
    remove_index :product_variants, :is_default
    remove_column :product_variants, :is_default
    remove_index :product_variants, :product_id
    remove_index :product_variants, :sku

    #categories table
    remove_index :categories, :parent_id

    #product_photos table
    remove_index :product_photos, :product_variant_id

     # products
    remove_index :products, :shipping_carrier
    remove_index :products, :status
    remove_index :products, :condition
  end
end
