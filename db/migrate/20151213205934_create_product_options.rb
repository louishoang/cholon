class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string :name, null: false
      t.integer :popularity

      t.timestamps null: false
    end
  end
end
