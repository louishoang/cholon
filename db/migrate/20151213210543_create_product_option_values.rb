class CreateProductOptionValues < ActiveRecord::Migration
  def change
    create_table :product_option_values do |t|
      t.string :name, null: false
      t.integer :product_option_id, null: false

      t.timestamps null: false
    end
  end
end
