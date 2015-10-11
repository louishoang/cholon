class ProductPhotosPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :product_photo

    def initialize(user, product_photo)
      @user = user
      @product_photo = product_photo
    end

    def resolve
      scope
    end
  end
end
