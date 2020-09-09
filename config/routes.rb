Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'

  resources :collaborators, only: [:show, :edit, :update] do
    get :products, on: :member
    get :history, on: :member
  end

  resources :products, only: [:show, :new, :create, :edit, :update] do
    resources :negotiations, only: [:new, :create]
    resources :comments, only: [:create, :show]
    get 'search', on: :collection
    get :photos, on: :member
    post 'invisible', on: :member
    post 'avaiable', on: :member
    post 'canceled', on: :member
  end

  resources :negotiations, only: [:index, :show] do
    resources :messages, only: [:create, :show]
    post 'negotiating', on: :member
    post 'canceled', on: :member
    get 'confirm', on: :member
    patch 'sold', on: :member
  end
end
