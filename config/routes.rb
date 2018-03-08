Rails.application.routes.draw do
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
  get "show_old/:id", to: "users#show_old"
  get "account_old", to: "accounts#show_old"
  resource :account, only: [:show, :edit, :update]
  get "destroy_account", to: "accounts#destroy_account"
  
  get "onboarding_first", to: "accounts#onboarding_first"
  post "onboarding_first_update", to: "accounts#onboarding_first_update"
  get "onboarding_second", to: "accounts#onboarding_second"
  post "onboarding_second_update", to: "accounts#onboarding_second_update"
  get "onboarding_third", to: "accounts#onboarding_third"
  post "onboarding_third_update", to: "accounts#onboarding_third_update"
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

  # get 'shop', to: 'shop#show'
  get 'direct_request', to: 'shop#show'
  
  # get 'network_show_old',  to: 'networks#show_original'
  resource :network, only: [:show] do
    get :search
    get :search_any
    get :search_one
  end
  get 'members',  to: 'networks#show', as: 'user_root'
  get 'members',  to: 'networks#show'
  get 'members/search',  to: 'networks#search'
  get 'members/search_any',  to: 'networks#search_any'
  get 'members/search_one',  to: 'networks#search_one'
  # resources :event_posts, path: 'news', only: [:index, :show], as: 'events'
  resources :event_posts, path: 'news', only: [:show], as: 'events'
  # get 'events_18', to: 'event_posts#index_18'
  get 'news', to: 'event_posts#index_18', as: :events
  
  resources :beeleever_posts, only: [:index, :create]
  resources :comments, only: [:create]
  # resources :partners, only: [:index]
  # get 'partners_18',     to: 'partners#index_18', as: :partners_18
  get 'partners',     to: 'partners#index_18', as: :partners

  # get 'team',     to: 'home#team',        as: :team
  # get 'team_18',     to: 'home#team_18',  as: :team_18
  get 'team',     to: 'home#team_18',        as: :team
  get 'pricing',  to: 'home#pricing',     as: :pricing
  get 'gtc',      to: 'home#gtc',         as: :gtc
  get 'legal',    to: 'home#legal',       as: :legal
  get 'faq',      to: 'home#faq',         as: :faq
  get 'adp',      to: 'adp#show',         as: :adp

  # root to: 'home#index'
  root to: 'home#home_18'
  # get 'home_18', to: 'home#home_18'

  get 'components', to: 'home#components'

  match "/404", :to => "errors#not_found", :via => :all
  match "/422", :to => "errors#unacceptable", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
end
