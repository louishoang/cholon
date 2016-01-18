module Productable
  extend ActiveSupport::Concern

  def created_at_i
    self.created_at.to_i
  end

  def updated_at_i
    self.updated_at.to_i
  end

  def product_image
    self.variant_with_photo.first.default_image.photo(:medium) rescue nil
  end
end