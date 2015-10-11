class CategoryPolicy < ApplicationPolicy
  #NOTE: when user has roles then need to change this controller
  attr_reader :user, :category

  def initialize(user, category)
    @user = user
    @category = category
  end

  def new?
    true
  end

  def create?
    true
  end
end