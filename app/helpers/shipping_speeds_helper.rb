module ShippingSpeedsHelper
  def rate_to_string(rate)
    "<strong>#{rate[:name]}</strong> - #{number_to_currency(rate[:price].to_f / 100, locale: :en)} &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #{t("Est Delivery")}: #{timeframe_to_string(rate[:timeframe])}".html_safe
  end
end
