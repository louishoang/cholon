class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
  end

  def sub_category
    @categories = Category.where("parent_id = ?", params[:category_id])
                    .order(:name).map{|x| [t("#{x.name}"), x.id]}
      
    render(:partial => "sub_category.html", :locals => {entities: @categories})
  end
end