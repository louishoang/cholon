class ProductPhotosController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @product_photo = ProductPhoto.new
    render :partial => "new.html"
  end

  def create
    @product_photo = ProductPhoto.new(product_photo_params)
    if @product_photo.save
      respond_to do |format|
        format.json{ render :json => @product_photo }
      end
    else
      respond_to do |format|
        format.json { render json: @product_photo.errors.full_messages.to_sentence, status: :unprocessable_entity}
      end
    end
  end

  private

  def product_photo_params
    params.require(:product_photo).permit(:photo)
  end
end