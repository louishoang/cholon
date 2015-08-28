Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  root 'home#index'
  resource :home

  resource :products

  resource :categories do 
    collection do
      get "sub_category"
    end
  end
end
