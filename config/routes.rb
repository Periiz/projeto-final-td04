Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update] do
    get :products, on: :member
  end

  resources :products, only: [:show, :new, :create] do
    resources :negotiations, only: [:new, :create]
    get 'search', on: :collection
  end

  resources :negotiations, only: [:index, :show, :edit, :update]
end
