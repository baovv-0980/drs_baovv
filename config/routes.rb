Rails.application.routes.draw do
  root "static_pages#index"
  devise_for :users

  as :user do
    get "/signin", to: "devise/sessions#new"
    post "/signin", to: "devise/sessions#create"
    delete "/signout", to: "devise/sessions#destroy"
  end
  resources :groups, only: [:show]
  resources :reports, except: [:edit, :update, :destroy]
  resources :requests
  resources :approve_requests, only: [:index, :show, :update]
  resources :manage_members
  resources :add_members, only: [:index, :create, :show]
  resources :admin_manage_users
  resources :errors, only: [:index]
  resources :manage_divisions
  resources :manage_reports, only: [:show]
  resources :profiles, only: [:index, :show, :edit, :update]
  resources :manager_show_reports, only: [:index]
  resources :reset_passwords, only: [:edit, :update]
  resources :notifications, only: [:index, :show]
  resources :manage_groups
  resources :manage_projects, only: [:index, :show]
  mount ActionCable.server => "/cable"
end
