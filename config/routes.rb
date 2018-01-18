Rails.application.routes.draw do
  get 'connection_propositions/show'

  devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self) #Original 
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  devise_scope :user do
    get 'shop', to: 'shop#show'
  end

  resources :users, only: [:show]
  resource :account
  resource :network, only: [:show] do
    get :search
  end
  resource :activity, only: [:show]
  resource :my_network, only: [:show]
  resources :connection_demands, only: [:new, :create, :show, :update]
  resources :connection_requests, only: [:new, :edit, :create, :update]
  resources :connection_propositions, only: [:show, :update]
  resources :feedbacks, only: [:new, :edit, :create, :update]
  resources :orders, only: [:create]
  resources :products,
            only: [:show],
            constraints: lambda { |request| request.xhr? }

  get 'shop', to: 'shop#show'
  get 'network',  to: 'networks#show', as: 'user_root'
  resources :event_posts, path: 'news', only: [:index, :show], as: 'events'
  get 'events_18', to: 'event_posts#index_18'
  
  resources :beeleever_posts, only: [:index, :create]
  resources :comments, only: [:create]
  resources :partners, only: [:index]
  get 'partners_18',     to: 'partners#index_18', as: :partners_18

  get 'team',     to: 'home#team',        as: :team
  get 'team_18',     to: 'home#team_18',  as: :team_18
  get 'pricing',  to: 'home#pricing',     as: :pricing
  get 'gtc',      to: 'home#gtc',         as: :gtc
  get 'legal',    to: 'home#legal',       as: :legal
  get 'faq',      to: 'home#faq',         as: :faq
  get 'adp',      to: 'adp#show',         as: :adp

  root to: 'home#index'
  get 'home_18', to: 'home#home_18'

  get 'components', to: 'home#components'
end
