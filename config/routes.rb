Rails.application.routes.draw do
  root "static_pages#index"

  resources :reports, except: [:edit, :update, :destroy]
  resources :requests, except: [:edit]
  resources :approve_requests, only: [:index, :show, :update]
  resources :manage_members, only: [:index, :update]
  resources :add_members, only: [:index, :update]
  resources :admin_manage_users, except: [:show]
  resources :notifications
  resources :errors, only: [:index]
  mount ActionCable.server => "/cable"
end
