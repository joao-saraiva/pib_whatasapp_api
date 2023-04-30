# frozen_string_literal: true

Rails.application.routes.draw do
  resources :player_per_matches do 
    collection do 
      patch 'give_up'
    end
  end

  resources :players
  resources :matches
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
