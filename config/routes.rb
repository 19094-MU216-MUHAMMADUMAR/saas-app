Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # Dashboard routes (authenticated users)
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  
  # Organization routes
  resource :organization, only: [:show, :edit, :update]
  
  # User management routes
  resources :users do
    collection do
      get :invite
      post :send_invitation
    end
  end
  
  # Project management routes
  resources :projects do
    member do
      delete 'remove_file/:attachment_id', action: :remove_file, as: :remove_file
    end
  end
  
  # Subscription and billing routes
  resource :subscription, only: [:show, :edit] do
    member do
      post :create_checkout_session
      get :success
      post :manage_billing
    end
  end
  
  # Webhook routes
  post '/webhooks/stripe', to: 'webhooks#stripe'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
