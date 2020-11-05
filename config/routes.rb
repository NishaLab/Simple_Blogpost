# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    unlocks: "users/unlocks",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/sign_up", to: "users#new"
  get "/users/:id/export", to: "users#export", as: "export"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  # get "/auth/:provider/callback", to: "sessions#omniauth"
  patch "/users/read/:id", to: "users#read_notification", as: "users_read"

  resources :microposts, only: %i(create destroy)
  resources :users
  resources :account_activation, only: [:edit]
  resources :password_resets, only: %i(new create edit update)
  resources :reactions, only: %i(create destroy update)
  resources :messages, only: %i(create)
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i(create destroy)
  mount ActionCable.server => "/cable"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "static_pages#home"
end
