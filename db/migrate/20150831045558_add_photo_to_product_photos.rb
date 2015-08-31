class AddPhotoToProductPhotos < ActiveRecord::Migration
  def up
    add_attachment :product_photos, :photo
  end

  def down
    remove_attachment :product_photos, :photo
  end
end
