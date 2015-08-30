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
      get 'create_variants'
      post 'create_variants'
    end
  end

  resources :product_variants
  resources :product_photos
end
