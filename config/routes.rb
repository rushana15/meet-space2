Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  get "up" => "rails/health#show", as: :rails_health_check
  get "profile/:id", to: "pages#profile", as: :profile
  # Defines the root path route ("/")
  # root "posts#index"
  resources :venues do
    collection do
      get 'category/:category', to: 'venues#category', as: :category
    end
    resources :bookings, only: [:new, :create]
    resources :reviews, only: %i[new create]
    resources :favorites, only: %i[create destroy]
  end

  resources :bookings, only: [:show] do
    resources :events, only: [:new, :create]
  end

  resources :bookings, only: [:destroy] do
    member do
      patch :confirm
    end
  end

  resources :chatrooms, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :venues do
    resources :reviews, only: [:new, :create]
  end
  resources :events, except: %i[new create] do
    resources :event_bookings, only: [:new, :create]
  end

  resources :reviews, only: [:destroy]
  resources :chatrooms, only: [:destroy]
  resources :messages, only: [:destroy]
  resources :favorites, only: [:index]
end
