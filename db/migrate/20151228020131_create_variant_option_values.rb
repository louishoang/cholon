class CreateVariantOptionValues < ActiveRecord::Migration
  def change
    create_table :variant_option_values do |t|
      t.integer :product_option_value_id, null: false
      t.integer :product_variant_id, null: false

      t.timestamps null: false
    end

    add_index :variant_option_values, [:product_variant_id, :product_option_value_id], :name => "variant_option_values_index"
  end
end
