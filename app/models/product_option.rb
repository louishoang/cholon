class ProductOption < ActiveRecord::Base
  include Indexable
  has_many :product_option_values
  validates :name, :presence => true

  before_create :index_name

  def self.search_for(term)
    Rails.cache.fetch(["search-product-option", term]) do
      product_options = where("name LIKE ?", "#{term}_%")
      product_options.order("popularity desc").limit(10).pluck(:name)
    end
  end

  private
  def index_by_name
    index_term(self.name)
    self.name.split.each{|t| index_term(t)}
  end
end
