class HomeController < ApplicationController

  def index
    @feature_products = Product.take(6)

    @trending_product_ids = OrderItem.trending.take(10).map(&:product_id) rescue []

    if @trending_product_ids.blank? || @trending_product_ids.size < 10
      extra_product_needed = 10 - @trending_product_ids.size 
      @trending_product = []
      @trending_product << Product.order("RAND(id)").where.not(:id => [1, 2,3])
        .take(extra_product_needed)
      @trending_product << Product.where(:id => @trending_product_ids)
    else
      @trending_product = Product.where(:id => @trending_product_ids)
    end
  end
end