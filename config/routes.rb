Moving::Application.routes.draw do

  resources :forfaits
  resources :supplies
  resources :trucks
  resources :quotes do
    resources :quote_confirmations, :only => [:new, :create, :edit, :update]
    member do
      get '/confirmation', :controller => :quote_confirmations, :action => 'new'
    end
  end
  devise_for :users
  resources :clients do
    get 'cities', :on => :collection
  end
  resources :storages do
    resources :annexes
  end
    
  resources :documents
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  root :to => 'dashboard#show'
end
