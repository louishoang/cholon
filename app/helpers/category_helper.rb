module CategoryHelper
  def top_level_category_select(name, selected = nil, options = {})
    list = ["Laptops & Tablets & Desktops", "Digital Electronics",
            "Other Electronics", "Beauty", "Womens Fashions",
            "Mens Fashions", "Baby & Kids"]
    categories = Category.where(:name => list).order(:name).map{|x| [t("#{x.name}"), x.id]}

    select_tag(name, options_for_select(categories, selected), options)
  end
end
