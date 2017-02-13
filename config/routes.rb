Rails.application.routes.draw do
  namespace :api, path: '/' do
    resources :articles do
      resources :comments, only: [:index, :create]
    end
  end
end
