Rails.application.routes.draw do
  root "static_pages#index"

  resources :reports, except: [:edit, :update, :destroy]
  resources :requests, except: [:edit]
  resources :approve_requests
end
