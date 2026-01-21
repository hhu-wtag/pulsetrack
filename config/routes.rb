Rails.application.routes.draw do
  namespace :teams do
    get "switches/create"
  end
  devise_for :users, path: "user"
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resource :user, only: [ :show ], controller: "users"

  resources :monitored_sites do
    member do
      patch :in_maintenance
      patch :out_maintenance
    end

    resources :check_results, only: [ :index, :show ]
  end

  resources :teams, only: [ :index, :show ] do
    resources :team_memberships, only: [ :index, :new, :create, :destroy ]
  end

  root "pages#home", as: :home

  get "up" => "rails/health#show", as: :rails_health_check
end
