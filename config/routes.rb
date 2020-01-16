Rails.application.routes.draw do
  root "static_pages#index"

  resources :reports, only: [:index, :new, :create]
end
