Rails.application.routes.draw do
  devise_for :users
  namespace :api, path: '/' do
    resources :articles do
      resources :comments, only: [:index, :create]
    end
  end
end
