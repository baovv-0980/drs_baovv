Rails.application.routes.draw do
  root "static_pages#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :reports, except: [:edit, :update, :destroy]
  resources :requests
  resources :approve_requests, only: [:index, :show, :update]
  resources :manage_members, only: [:index, :update]
  resources :add_members, only: [:index, :update]
  resources :admin_manage_users
  resources :errors, only: [:index]
  resources :manage_divisions
  resources :manage_reports, only: [:show]
  resources :profiles, only: [:index, :show, :edit, :update]
  resources :manager_show_reports, only: [:index]
  resources :reset_passwords, only: [:edit, :update]
  resources :notifications, only: [:index, :show]
  mount ActionCable.server => "/cable"
end
