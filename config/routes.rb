Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update]
  resources :products, only: [:show, :new, :create]
end
