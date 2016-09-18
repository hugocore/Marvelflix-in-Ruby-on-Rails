Rails.application.routes.draw do
  devise_for :users
  root 'comics#index'

  resource :comics, only: [:index]
  # resource :characters
end
