class ProductsController < ApplicationController
  include CacheManager

  before_action :authenticate_user!
  prepend_before_filter :find_product, :only => [:create_variants, :edit, :update, :show, :shipping_handling, :calculate_shipping, :preview, :set_publishable, :create_product_attributes]
  before_filter :clear_browser_cache, :only => [:new, :create_variants]
  after_action :verify_authorized, :only => [:edit, :update, :preview, :destroy] 

  def index
    @products = Product.join_all.publishable
      .with_condition(params[:condition])
      .price_between([params[:min_price], params[:max_price]])

    @min_price = @products.minimum("price").to_f rescue Product.minimum("price").to_f

    @max_price = @products.maximum("price").to_f rescue Product.maximum("price").to_f

    @products = @products.page(params[:page]).per(current_per_page)
  end

  def show
    @default_variant = @product.default_variant

    @product_option_hash = ProductOptionValue.joins(:product_variants)
      .where("product_variants.id IN (?)", @product.product_variants.map(&:id))
      .uniq.group_by(&:product_option_id)
  end

  def new
    @product = Product.new
  end

  def create
    handle_create_or_update
    if @product.persisted?
      set_product_to_cookie(@product)
      create_variant_and_redirect(params, @product)
    else
      respond_to do |format|
        format.json { render json: {:message => @product.errors.full_messages.to_sentence}, status: :unprocessable_entity  }
        format.html { render action: "new" }
      end
    end
  end

  def create_variants
    if request.post?
      @option_value_ids = params[:product_option_value_ids].split(",")

      @product_option_hash = ProductOptionValue.where(:id => @option_value_ids)
        .group_by(&:product_option_id)

      first_array, *remaining_arrays = @product_option_hash.values

      if remaining_arrays.blank?
        first_array.each do |option_value|
          product_variant = ProductVariant.find_or_initialize_by(:name => option_value.name)
          product_variant.product_option_values << option_value
          @product.product_variants << product_variant
        end
      else
        option_values_combination = first_array.product(*remaining_arrays)

        option_values_combination.each do |combo|
          name = combo.map(&:name).join("-")
          product_variant = ProductVariant.find_or_initialize_by(name: name)
          product_variant.product_option_values << combo
          @product.product_variants << product_variant
        end
      end

      if @product.save
        respond_to do |format|
          format.json{ render json: {:location => create_variants_product_path(@product) }}
        end
      else
        respond_to do |format|
          format.json { render json: {:message => @product.errors.full_messages.to_sentence }, status: :unprocessable_entity }
          format.html { render action: "create_product_attributes" }
        end
      end
    end
  end

  def update
    authorize @product
    fix_params_product_photo_ids
    @product.status = Product.statuses[:preview] unless [Product.statuses[:publishable], Product.statuses[:preview]].include?(@product.status)
    if @product.update_attributes(product_params)
      if params[:next_url].present?
        render js: "window.location='#{preview_product_path(@product, checked: true)}'"
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
    authorize @product

    @product_option_hash = ProductOptionValue.joins(:product_variants)
      .where("product_variants.product_id = ?", @product.id)
      .uniq
      .group_by(&:product_option_id)

    @default_variant = @product.default_variant
    unless params[:checked].present?
      @product.status = Product.statuses[:preview] unless [Product.statuses[:publishable], Product.statuses[:preview]].include?(@product.status)
      if @product.save
        respond_to do |format|
          format.json{ render json: {:location => preview_product_path(@product, checked: true) }}
        end
      else
        respond_to do |format|
          format.json { render json: {:message => @product.errors.full_messages.to_sentence }, status: :unprocessable_entity }
        end
      end
    end
  end

  def set_publishable
    @product.status = Product.statuses[:publishable]
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

  def create_product_attributes
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
      product_variants_attributes: [:id, :name, :price, :stock_quantity, :condition, product_photo_ids: []])
  end

  def find_product
    @product = Product.find_by_slug(params[:id])
  end

  def create_variant_and_redirect(params, product)
    if params[:has_variants].present? && params[:has_variants] == 'true'
      #redirect to create variants page
      redirect_url = create_product_attributes_product_path(id: product)
      respond_to do |format|
        format.json {render json: {:location => redirect_url }}
      end
    else
      #create a default variant and redirect to upload photo page
      default_variant = product.create_default_variant
      redirect_url = "#{new_product_photo_path(product_variant_id: default_variant.id) }"
      respond_to do |format|
        format.json{ render json: {:location => redirect_url }}
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
end