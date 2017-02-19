Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api, path: '/' do
    resources :articles do
      resources :comments, only: [:index, :create]
    end
  end
end
