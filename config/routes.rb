Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  devise_for :users
  namespace :api, path: '/' do
    resources :articles do
      resources :comments, only: [:index, :create]
    end
  end
end
