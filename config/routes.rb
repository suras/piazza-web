require "sidekiq/web"

Rails.application.routes.draw do
  get 'feed/show'
  get 'users/new'
  get 'users/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "feed#show"
   
  get "sign_up", to: "users#new"

  post "sign_up", to: "users#create"

  get "login", to: "sessions#new"

  post "login", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  resource :profile, only: [:show, :update], controller: "users"

  resources :listings, except: :index do
    scope module: :listings do
      post :draft, to: "drafts#create", on: :collection
      patch :draft, to: "drafts#update"
    end
    resource :saved_listings, only: [:create, :destroy], path: "save"
  end
  
  # only for cosmetic reeasons
  resource :saved_listings, only: :show

  resource :my_listings, only: :show

  namespace :users do
    patch "change_password", to: "passwords#update"
    resources :password_resets, only: [:new, :create, :update, :edit]
    resources :activation, only: [:show]
  end

  mount Sidekiq::Web => '/sidekiq'

end

# Draft Routes:

#     POST /listings/draft -> Listings::DraftsController#create
#     PATCH /listings/:id/draft -> Listings::DraftsController#update

# Saved Listings Routes:

#     POST /listings/:listing_id/save -> SavedListingsController#create
#     DELETE /listings/:listing_id/save -> SavedListingsController#destroy