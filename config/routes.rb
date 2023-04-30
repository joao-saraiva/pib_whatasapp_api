# frozen_string_literal: true

Rails.application.routes.draw do
  resources :player_per_matches do 
    collection do 
      patch 'give_up'
    end
  end

  resources :players

  resources :matches do 
    collection do 
      patch 'cancel'
    end
  end
end
