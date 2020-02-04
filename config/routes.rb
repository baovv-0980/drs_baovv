Rails.application.routes.draw do
  root "static_pages#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :reports, except: [:edit, :update, :destroy]
  resources :requests, except: [:edit]
  resources :approve_requests, only: [:index, :show, :update]
  resources :manage_members, only: [:index, :update]
  resources :add_members, only: [:index, :update]
  resources :admin_manage_users, except: [:show]
  resources :errors, only: [:index]
  resources :manage_divisions
  resources :manage_reports, only: [:show]
  resources :profiles, only: [:edit, :update]
  resources :manager_show_reports, only: [:index]
  mount ActionCable.server => "/cable"
end
