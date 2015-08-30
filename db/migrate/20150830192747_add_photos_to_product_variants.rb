class AddPhotosToProductVariants < ActiveRecord::Migration
  def up
    add_column :product_variants, :photos, :text
  end

  def down
    remove_column :product_variants, :photos
  end
end
