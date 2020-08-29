Rails.application.routes.draw do
  devise_for :collaborators
  root to: 'home#index'
end
