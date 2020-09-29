# frozen_string_literal: true

Rails.application.routes.draw do
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/sign_up', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :microposts, only: %i[create destroy]
  resources :users
  resources :account_activation, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :users do
    member do
      get :following, :followers
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
end
