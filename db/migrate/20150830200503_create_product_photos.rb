class CreateProductPhotos < ActiveRecord::Migration
  def change
    create_table :product_photos do |t|
      t.string :photos
      t.integer :product_variant_id

      t.timestamps
    end
  end
end
