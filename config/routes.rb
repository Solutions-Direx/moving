Moving::Application.routes.draw do
  
  # match 'calendar' => 'calendar#show', :as => 'calendar'
  match 'schedule' => 'schedule#show', :as => 'schedule'
  get 'new_invoice' => "invoices#new", :as => "new_invoice"
  resources :forfaits
  resources :supplies
  resources :trucks
  resources :quotes do
    resources :quote_confirmations, :except => [:index]
    # HAS ONE ROUTES
    resource :invoice, :only => [:show, :edit, :update] do
      post "sign"
    end
    resource :report, :only => [:show, :edit, :update] do
      post "sign"
    end
    member do
      post "sign"
      get '/confirmation', :controller => :quote_confirmations, :action => 'new'
      put 'daily_update'
      get 'terms'
      put 'reject'
      post 'email'
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
    collection do
      get 'export'
      get 'reports'
    end
  end
  resources :documents
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  root :to => 'dashboard#show'
end
