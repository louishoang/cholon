class CategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, :only => [:new, :create] 

  def index
  end

  def new
    authorize @category
  end

  def create
    authorize @category
  end

  def sub_category
    @categories = Category.where("parent_id = ?", params[:category_id])
                    .order(:name).map{|x| [t("#{x.name}"), x.id]}
      
    render(:partial => "sub_category.html", :locals => {entities: @categories})
  end
end