module CacheManager
  def clear_browser_cache
    response.headers["Pragma"] = "no-cache"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"    
    response.headers["Expires"] = "Fri, 01 Jan 1970 00:00:00 GMT"
  end

  def set_product_to_cookie(product)
    # set cookie to prevent browser back button allow user to submit form again
    cookies[:product_name] = product.name.gsub(" ", "")
    cookies[:product_slug] = product.slug
  end
end