Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  root 'home#index'

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
end
