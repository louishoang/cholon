class ProductPhotosController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @product_photo = ProductPhoto.new
    if params[:popup].present?
      render :partial => "new.html"
    else
    end
  end

  def create
    @product_photo = ProductPhoto.new(product_photo_params)
    if params[:product_variant_id].present?
      @product_photo.product_variant_id = params[:product_variant_id]
    end
    if @product_photo.save
      respond_to do |format|
        format.json{ render :json => @product_photo.to_json }
      end
    else
      respond_to do |format|
        format.json { render json: @product_photo.errors.full_messages.to_sentence, status: :unprocessable_entity}
      end
    end
  end

  def gallery
    @product_photos = ProductPhoto.where(:id => params[:ids].split(","))
    render :partial => "/product_photos/gallery.html", locals: {:entities => @product_photos}
  end

  private

  def product_photo_params
    params.require(:product_photo).permit(:photo, :product_variant_id)
  end
end