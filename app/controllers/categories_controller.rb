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
    @category_id = params[:category_id]
    @categories = Category.where("parent_id = ?", @category_id)
                    .order(:name).map{|x| [t("#{x.name}"), x.id]}

    if @categories.present?
      render(:partial => "sub_category.html")
    else
      render :nothing => true
    end
  end

  def select_category
    render(:partial => "select_category.html")
  end
end