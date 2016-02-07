module Productable
  extend ActiveSupport::Concern

  def created_at_i
    self.created_at.to_i
  end

  def updated_at_i
    self.updated_at.to_i
  end

  def product_image
    self.variant_with_photo.first.default_image.photo(:medium) rescue nil
  end

  def category_ids
    list = []
    first_cat = self.categories.first
    list << first_cat.id
    parent = first_cat.parent_category rescue nil
    if parent.present?
      list << parent.id
    end
    list
  end

  def average_selling_rating
    rand(0.0..5.0).round(1)
  end

  class_methods do
    
  end

  included do
    scope :join_all, lambda{ |*args|
      select("DISTINCT products.*")
      .joins("LEFT OUTER JOIN product_variants ON products.id = product_variants.product_id")
      .joins("LEFT OUTER JOIN product_categories ON products.id = product_categories.product_id")
      .joins("LEFT OUTER JOIN categories ON product_categories.category_id = categories.id")
    }

    scope :publishable, -> { where(status: Product.statuses[:publishable]) }

    scope :with_categories, lambda{ |*args|
      if args.present? && args[0].present?
        category_ids = args[0].split(",")
        where("categories.id IN (?)", category_ids)
      end
    } 

    scope :with_category, lambda{ |args|
      if args.present?
        where("categories.id = ?", args)
      end
    } 

    scope :with_condition, lambda{ |args|
      if args.present?
        where("products.condition = ?", args)
      end
    }

    scope :price_between, lambda { |args|
      if args.present? && args.is_a?(Array) && args[0].present?
        lowest_price = args[0]
        highest_price = args[1]
        if lowest_price.to_f == highest_price.to_f
          highest_price = highest_price.to_f + 1
        end
        where("products.price BETWEEN ? AND ?", lowest_price, highest_price)
      end
    }
  end
end