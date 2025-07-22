Rails.application.routes.draw do
  # Add this admin namespace
  namespace :admin do
    root 'dashboard#index'

    resources :orders, only: [:index, :show, :edit, :update] do
      member do
        patch :cancel
      end
      collection do
        patch :bulk_cancel
      end
    end
    resources :products
    resources :users
  end

  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get 'cart', to: 'cart#show', as: :cart
  get 'checkout', to: 'orders#checkout', as: :checkout

  resources :products, only: %i[index show] do
    resources :orders, only: %i[new create]
    resources :user_designs, only: %i[new create]
    resources :order_items, only: %i[new create]
  end

  resources :order_items, only: [:index, :show, :edit, :update, :destroy]
  resources :orders, only: %i[index show edit update destroy]
  resources :user_designs, only: %i[index show edit update destroy]
  resource :profile, only: [:show, :edit, :update]
end
