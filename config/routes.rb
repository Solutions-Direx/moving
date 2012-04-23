Moving::Application.routes.draw do
  
  # match 'calendar' => 'calendar#show', :as => 'calendar'
  match 'schedule' => 'schedule#show', :as => 'schedule'
  resources :forfaits
  resources :supplies
  resources :trucks
  resources :quotes do
    resources :quote_confirmations, :only => [:new, :create, :edit, :update]
    member do
      get '/confirmation', :controller => :quote_confirmations, :action => 'new'
      put 'daily_update'
    end
    
    collection do
      get '/pending'
      get 'monthly'
      get 'daily'
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
