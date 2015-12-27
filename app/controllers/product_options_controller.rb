class ProductOptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: ProductOption.search_for(params[:term])
  end

  def new
    @option = ProductOption.new
    @option.product_option_values << ProductOptionValue.new
    render :partial => "new"
  end

  def create
    @option = ProductOption.find_or_create_by(name: params[:product_option][:name])
    @product_option_values = []
    product_option_value_params.each do |_value|
      @product_option_values << ProductOptionValue.find_or_create_by(name: _value[1]["name"])
    end
    @option.product_option_values << @product_option_values
    if @option.persisted?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.json { render json: {:message => @option.errors.full_messages.to_sentence }, status: :unprocessable_entity }
      end
    end
  end

  def edit_product_attributes
    @option = ProductOption.find(params[:option])
    @option_values = ProductOptionValue.where(:id => params[:option_values])
    render :partial => "edit_product_attributes"
  end

  private
  def product_option_value_params
    params[:product_option][:product_option_values_attributes].reject do |k,v|
      v["name"].blank?
    end
  end

  def product_option_params
    params.require(:product_option).permit(:name, :popularity, product_option_values_attributes: [:name, :product_option_id])
  end
end
