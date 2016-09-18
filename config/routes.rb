Rails.application.routes.draw do
  root 'comics#index'

  resource :comics, only: [:index]
  # resource :characters
end
