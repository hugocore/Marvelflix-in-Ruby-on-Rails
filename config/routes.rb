Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  devise_for :users
  root 'comics#index'

  resources :comics, only: [:index] do
    resources :upvotes, only: [:create] do
      collection do
        delete 'delete' # we don't need the comic_id for deletion because its a single instance
      end
    end
  end

  resources :characters, only: [:index]
end
