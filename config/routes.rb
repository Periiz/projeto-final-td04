Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update]
  resources :products, only: [:show, :new, :create] #do get comments depois
  get 'collaborators/:id/all', to: 'collaborators#all_products'
end
