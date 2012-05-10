Moving::Application.routes.draw do
  
  # match 'calendar' => 'calendar#show', :as => 'calendar'
  match 'schedule' => 'schedule#show', :as => 'schedule'
  get 'new_invoice' => "invoices#new", :as => "new_invoice"
  resources :forfaits
  resources :supplies
  resources :trucks
  resources :quotes do
    resources :quote_confirmations, :except => [:index]
    resources :removals, :only => [:update] do
      post "sign", :on => :member
    end
    # HAS ONE ROUTES
    resource :invoice, :only => [:show, :edit, :update] do
      post "sign"
    end
    resource :report, :only => [:show, :edit, :update] do
      post "sign"
    end
    member do
      get '/confirmation', :controller => :quote_confirmations, :action => 'new'
      put 'daily_update'
      get 'terms'
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
  
  resources :invoices, :only => :index do
    get 'export', :on => :collection, :as => 'export'
  end
  resources :documents
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  root :to => 'dashboard#show'
end
