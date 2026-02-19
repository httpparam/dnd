Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"

  get "/login", to: "sessions#new"
  get "/oauth/callback", to: "sessions#callback"
  get "/auth/hackclub/callback", to: "sessions#callback"
  delete "/logout", to: "sessions#destroy"

  resource :profile, only: [:update]
  get "/onboarding", to: "onboarding#index"
  resources :campaigns, only: [:create, :show, :destroy] do
    resources :campaign_messages, only: [:create]
    resources :campaign_memberships, only: [:destroy]
    resources :campaign_join_requests, only: [:create, :destroy] do
      member do
        post :approve
        post :deny
      end
    end
  end
  resource :queue, only: [:create, :destroy]
end
