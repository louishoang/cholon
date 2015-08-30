class ProductPhotosController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @product_photo = ProductPhoto.new
    render :partial => "new.html"
  end

  def create
  end
end