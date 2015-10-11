class UpsellingsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_product, :only => [:similar_products]
  
  def similar_products
    @similar_products = Product.join_all.publishable
      .where("products.id != ?", @product.id)
      .with_category(@product.categories.first)

    if @simlar_products.blank?
      @similar_products = Product.publishable.where("products.id != ?", @product.id)
        .order("RANDOM()").limit(4)
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def find_product
    @product = Product.find_by_slug(params[:offer_id])
  end
end