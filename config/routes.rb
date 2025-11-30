Rails.application.routes.draw do
  devise_for :users
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root "pages#home", as: :home

  resources :monitored_sites do
    resources :check_results, only: [ :index, :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
