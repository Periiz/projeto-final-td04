Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update] do
    get :products, on: :member
  end

  resources :products, only: [:show, :new, :create] do
    resources :negotiations, only: [:new, :create]
    resources :comments, only: [:create, :show]
    get 'search', on: :collection
    post 'invisible', on: :member
    post 'avaiable', on: :member
    post 'canceled', on: :member
  end

  resources :negotiations, only: [:index, :show, :edit, :update] do
    resources :messages, only: [:create, :show]
    post 'negotiating', on: :member
    post 'sold', on: :member
    post 'canceled', on: :member
  end
end
