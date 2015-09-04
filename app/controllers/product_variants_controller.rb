class ProductVariantsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def clone_form
    render :partial => "/product_variants/entity.html"
  end
end