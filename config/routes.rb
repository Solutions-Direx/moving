Moving::Application.routes.draw do

  resources :storages
  resources :documents
  resource :account, :only => [:show, :update]
  
  devise_for :users 
  resources :users
  root :to => 'dashboard#show'
end
