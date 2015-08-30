class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_product, :only => [:create_variants, :edit, :update, :show]

  def index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      if params[:has_variants].present? && params[:has_variants] == true
        #redirect to create variants page
        render js: "window.location='#{products_path}'"
      else
        render js: "window.location='#{products_path}'"
      end
    else
      respond_to do |format|
        format.json { render json: @product.errors.full_messages.to_sentence, status: :unprocessable_entity }
        format.html { render action: "new" }
      end
    end
  end

  def create_variants
    @product.product_variants.build
  end

  private
  def product_params
    params.require(:product).permit(:name, :short_description,
      :price, :stock_quantity, :condition, :description,
      :user_id, category_ids: [], product_variants_attributes: [:name, :price, :stock_quantity, :condition])
  end

  def find_product
    @product = Product.find(params[:id])
  end
end