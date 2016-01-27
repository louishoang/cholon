Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  root 'home#index'
  get 'products/typeahead/:query' => 'products#typeahead'

  resources :categories do 
    collection do
      get "sub_category"
    end
  end

  resources :home

  resources :products do
    member do
      get 'set_publishable'
      get 'preview'
      post 'calculate_shipping'
      get 'shipping_handling'
      get 'create_variants'
      post 'create_variants'
      get 'create_product_attributes'
    end
  end

  # orders table doesn't have id column, use order number as primary key
  resources :orders , param: :order_number do
    member do
      get "result"
      post "result"
      get 'basket_info'
      get 'checkout'
    end
  end

  resources :order_items

  resources :shipping_speeds

  resources :upsellings do
    collection do
      get 'similar_products'
    end
  end

  resources :product_variants do
    collection do 
      get 'clone_form'
    end
  end
  
  resources :product_photos do
    collection do
      get 'gallery'
    end
  end

  resources :product_options do
    collection do
      get 'find_or_create_option'
      get 'edit_product_attributes'
    end
  end

end
