Rails.application.routes.draw do
  resources :servers do
    member do
      delete :remove_user
      post :resync
    end
  end

  devise_for :users, controllers: {registrations: "users/registrations"}, path: "accounts"
  resources :ssh_keys, only: %i[destroy]
  authenticated :user do
    resources :users do
      resources :ssh_keys, only: %i[new create destroy]
      member do
        get :sync_keys
      end
    end
  end

  match "bad-request", to: "errors#bad_request", as: "bad_request", via: :all
  match "not_authorized", to: "errors#not_authorized", as: "not_authorized", via: :all
  match "route-not-found", to: "errors#route_not_found", as: "route_not_found", via: :all
  match "resource-not-found", to: "errors#resource_not_found", as: "resource_not_found", via: :all
  match "missing-template", to: "errors#missing_template", as: "missing_template", via: :all
  match "not-acceptable", to: "errors#not_acceptable", as: "not_acceptable", via: :all
  match "unknown-error", to: "errors#unknown_error", as: "unknown_error", via: :all
  match "service-unavailable", to: "errors#service_unavailable", as: "service_unavailable", via: :all

  match "/400", to: "errors#bad_request", via: :all
  match "/401", to: "errors#not_authorized", via: :all
  match "/403", to: "errors#not_authorized", via: :all
  match "/404", to: "errors#resource_not_found", via: :all
  match "/406", to: "errors#not_acceptable", via: :all
  match "/422", to: "errors#not_acceptable", via: :all
  match "/500", to: "errors#unknown_error", via: :all

  root to: "welcome#index"
end
