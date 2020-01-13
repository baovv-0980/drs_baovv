Rails.application.routes.draw do
    root "static_pages#index"

    get "static_pages/index"
end
