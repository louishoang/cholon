class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    binding.pry
    if @product.save
      if params[:has_variants].present? && params[:has_variants] == true
        #redirect to create variants page
        format.html { redirect_to products_path, notice: 'Client was successfully created.' }
        format.json
      else
        format.html { redirect_to products_path, notice: 'Client was successfully created.' }
        format.json
      end
    else
      respond_to do |format|
        format.json { render json: @product.errors.full_messages.to_sentence, status: :unprocessable_entity }
        format.html { render action: "new" }
        # format.js{ render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :short_description,
      :price, :stock_quantity, :condition, :description,
      :user_id, category_ids: [])
  end
end