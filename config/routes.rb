Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update]
  resources :products, only: [:show, :new, :create] do
    resources :negotiations, only: [:new, :create]
  end
  get 'collaborators/:id/all', to: 'collaborators#all_products'
  resources :negotiations, only: [:index, :show, :edit, :update]
end
