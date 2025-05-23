Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :railrails_health_checks_health_check
  get 'privacy' => 'privacy#index'
  # Defines the root path route ("/")
  root 'home#index'

  resources :accounts do
    get :options, on: :collection
  end

  mount MobileApi::Root => '/'
  mount GrapeSwaggerRails::Engine => '/api/doc'
end
