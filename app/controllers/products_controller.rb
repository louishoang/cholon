class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_product, :only => [:create_variants, :edit, :update, :show, :shipping_handling, :calculate_shipping, :preview, :set_publishable]
  before_filter :clear_browser_cache, :only => [:new, :create_variants]

  def clear_browser_cache
    response.headers["Pragma"] = "no-cache"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"    
    response.headers["Expires"] = "Fri, 01 Jan 1970 00:00:00 GMT"
  end

  def index
    @products = Product.join_all.publishable
      .order(:name).page(params[:page]).per(current_per_page)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    handle_create_or_update
    if @product.persisted?
      # set cookie to prevent browser back button allow user to submit form again
      cookies[:product_name] = @product.name.gsub(" ", "")
      cookies[:product_slug] = @product.slug

      if params[:has_variants].present? && params[:has_variants] == 'true'
        #redirect to create variants page
        @redirect_url = create_variants_product_path(id: @product)
        respond_to do |format|
          format.json {render json: {:location => @redirect_url }}
        end
      else
        #create a default variant and redirect to upload photo page
        @default_variant = @product.create_default_variant
        @redirect_url = "#{new_product_photo_path(product_variant_id: @default_variant.id) }"
        respond_to do |format|
          format.json{ render json: {:location => @redirect_url }}
        end
      end
    else
      respond_to do |format|
        format.json { render json: {:message => @product.errors.full_messages.to_sentence}, status: :unprocessable_entity  }
        format.html { render action: "new" }
      end
    end
  end

  def handle_create_or_update
    # prevent user creates duplicated product by pressing back button, when he/she presses back button , params page_is_dirty is '1'
    if params[:page_is_dirty].present? && params[:page_is_dirty] == '1'
      @product = Product.find_by(slug: cookies[:product_slug], seller_id: current_user.id)
      if @product.present?
        @product.update_attributes(product_params)
      end
    else
      @product = Product.create(product_params)
    end
    @product
  end

  def create_variants
    @product.product_variants.build if @product.product_variants.blank?
  end

  def update
    fix_params_product_photo_ids
    @product.status = Product::STATUS_PREVIEW unless [Product::STATUS_PUBLISHABLE, Product::STATUS_PREVIEW].include?(@product.status)
    if @product.update_attributes(product_params)
      if params[:next_url].present?
        render js: "window.location='#{preview_product_path(@product)}'"
      else
        render js: "window.location='#{products_path}'"
      end
    else
      respond_to do |format|
        format.json { render json: {:message => @product.errors.full_messages.to_sentence }, status: :unprocessable_entity }
        format.html { render action: "create_variants" }
      end
    end
  end

  def preview
    unless params[:checked].present?
      @product.status = Product::STATUS_PREVIEW unless [Product::STATUS_PUBLISHABLE, Product::STATUS_PREVIEW].include?(@product.status)
      if @product.save
        redirect_to preview_product_path(@product, checked: true)
      else
        respond_to do |format|
          format.json { render json: {:message => @product.errors.full_messages.to_sentence }, status: :unprocessable_entity }
        end
      end
    end
  end

  def set_publishable
    @product.status = Product::STATUS_PUBLISHABLE
    if @product.save
      respond_to do |format|
        format.json {render json: {:location => products_path, :message => "Product is created successfully" }}
      end
    else
      respond_to do |format|
        format.json { render json: {:message => @product.errors.full_messages.to_sentence }, status: :unprocessable_entity }
      end
    end
  end

  def shipping_handling
    render :partial => "shipping_handling.html"
  end

  def calculate_shipping
    @shipping_options = @product.get_shipping_cost(params[:zipcode], params[:quantity])
    respond_to do |format|
      format.js
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
    params.require(:product).permit(:name, :price, :stock_quantity, :condition,
      :location, :shipping_method, :shipping_price, :shipping_carrier,
      :weight, :length, :width, :height,
      :description, :seller_id, :status, category_ids: [],
      product_variants_attributes: [:name, :price, :stock_quantity, :condition, product_photo_ids: []])
  end

  def find_product
    @product = Product.find_by_slug(params[:id])
  end
end