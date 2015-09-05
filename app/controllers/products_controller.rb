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
    @product.product_variants.build if @product.product_variants.blank?
  end

  def update
    fix_params_product_photo_ids
    if @product.update_attributes(product_params)
      render js: "window.location='#{products_path}'"
    else
      respond_to do |format|
        format.json { render json: @product.errors.full_messages.to_sentence, status: :unprocessable_entity }
        format.html { render action: "create_variants" }
      end
    end
  end

  private
  def fix_params_product_photo_ids
    # photo_ids are sending in as a string => need to convert it to an array
    variant_attrs = params[:product][:product_variants_attributes] rescue nil
    if variant_attrs.present?
      variant_attrs.each do |k, v|
        if v["product_photo_ids"].present? && v["product_photo_ids"].is_a?(String)
          v["product_photo_ids"] = JSON.parse(v["product_photo_ids"])
        end
      end
    end
  end

  def product_params
    params.require(:product).permit(:name, :short_description,
      :price, :stock_quantity, :condition, :description,
      :user_id, category_ids: [], product_variants_attributes: [:name, :price, :stock_quantity, :condition, product_photo_ids: []])
  end

  def find_product
    @product = Product.find(params[:id])
  end
end