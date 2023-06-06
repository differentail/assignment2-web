Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'books#index'

  resources :books do
    resources :reviews, only: %i[create edit update destroy]
  end
end
