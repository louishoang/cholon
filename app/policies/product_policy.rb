class ProductPolicy < ApplicationPolicy
  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def preview?
    product.seller == user
  end

  def update?
    product.seller == user
  end
end