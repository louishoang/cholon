class ProductOptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: %w[foo bar]
  end

  def new
    @option = ProductOption.new
    @option.product_option_values << ProductOptionValue.new
    render :partial => "new"
  end

  def create
  end
end
