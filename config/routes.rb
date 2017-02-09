Rails.application.routes.draw do
  namespace :api, path: '/' do
    resources :articles, only: [:index, :show] do
      resources :comments, only: [:index]
    end
  end
end
