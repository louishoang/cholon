module Reportable
  extend ActiveSupport::Concern

  included do
    scope :with_statuses, lambda{|*args|
      if args.present? && args[0].present?
        where("orders.status IN (?)", args.join(","))  
      end
    }

    scope :with_sellers, lambda{|*args|
      if args.present? && args[0].present?
        where("order_items.seller_id IN (?)", args.join(","))  
      end
    }

    scope :join_all, lambda{|*args|
      select("DISTINCT orders.*")
      .joins("LEFT OUTER JOIN users ON orders.user_id = users.id")
      .joins("LEFT OUTER JOIN order_items ON order_items.order_number = orders.order_number")
    }

    scope :statistic, lambda{|*args|
      select("orders.user_id, orders.order_number, orders.subtotal,
        orders.tax, orders.shipping_price, orders.total, orders.status,
        count(orders.order_number) AS orders_count,
        SUM(CASE WHEN (orders.status = 1) THEN IFNULL(order_items.total_price, 0) ELSE 0 END) AS pending_revenue,
        SUM(CASE WHEN (orders.status IN (2, 4)) THEN IFNULL(order_items.total_price, 0) ELSE 0 END) AS earned_revenue,
        SUM(CASE WHEN (orders.status = 1) THEN IFNULL(order_items.quantity, 0) ELSE 0 END) AS pending_items_count, 
        SUM(CASE WHEN (orders.status IN (2, 4)) THEN IFNULL(order_items.quantity, 0) ELSE 0 END) AS sold_items_count")
      .where("orders.status IN (?)", [1, 2, 4]) # 1, 2, 4 is placed, shipped, delivered
    }
  end
end