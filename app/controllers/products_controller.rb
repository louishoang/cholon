class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @product = Product.new
  end

  def create
  end
end