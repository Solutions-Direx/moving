Moving::Application.routes.draw do
  
  resources :quotes

  devise_for :users

  resources :options
  resources :clients
  resources :storages
  resources :documents
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  root :to => 'dashboard#show'
end
