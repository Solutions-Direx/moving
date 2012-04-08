Moving::Application.routes.draw do
  
  resources :supplies
  resources :trucks
  resources :quotes
  devise_for :users
  resources :clients do
    get 'cities', :on => :collection
  end
  resources :storages
  resources :documents
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  root :to => 'dashboard#show'
end
