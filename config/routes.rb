Rails.application.routes.draw do
  resources :imports, only: [ :new, :create, :show ]

  resources :categories
  root "films#index"

  resources :films do
    resources :comments, only: [ :create ]
  end

  devise_for :users

  require "sidekiq/web"
  authenticate :user do
    mount Sidekiq::Web => "/sidekiq"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
