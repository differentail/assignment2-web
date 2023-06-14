Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'books#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :books do
    resources :reviews, only: %i[create edit update destroy]
  end

  resources :ranks, only: %i[index show]
end
