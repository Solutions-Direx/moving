Moving::Application.routes.draw do

  # BACK OFFICE ROUTES
  # ==================
  devise_for :users
  
  # match 'calendar' => 'calendar#show', :as => 'calendar'
  match 'schedule' => 'schedule#show', :as => 'schedule'
  get 'new_invoice' => "invoices#new", :as => "new_invoice"
  get "audit" => "activities#index", :as => 'audit'
  resources :forfaits
  resources :supplies
  resources :trucks
  resources :quotes do
    resource :quote_confirmation, :except => [:index]
    # HAS ONE ROUTES
    resource :invoice, :only => [:new, :create, :show, :edit, :update] do
      post 'email'
      get 'print'
      post "sign"

      resources :payments
    end

    resource :report, :only => [:show, :edit, :update] do
      member do
        get  :quick_view
        post :sign
        post :verify
      end
    end
    resource :deposit, :only => [:new, :create]
    resource :billing_address, :only => [:edit, :update]
    member do
      get '/confirmation', :controller => :quote_confirmations, :action => 'new'
      put 'daily_update'
      put 'reject'
      put 'cancel_reject'
      post 'email'
      get 'print'
    end
    
    collection do
      get '/pending'
      get 'monthly'
      get 'daily'
    end
  end
  resources :clients do
    get 'cities', :on => :collection
  end
  resources :storages do
    resources :annexes
  end
  
  resources :reports, :only => :index do
    collection do
      get 'payments'
    end
  end
  resources :invoices, :only => :index do
    collection do
      get 'export'
      # get 'reports'
    end
  end
  resources :documents do
    get 'print', :on => :member
  end
  resource :account, :only => [:show, :update]
  resource :profile, :only => [:show, :update], :path => "users/profile"
  resources :users
  
  get 'search', :to => "dashboard#search"
  root :to => 'dashboard#show'
  
  # MOBILE ROUTES
  # ==================
  namespace :mobile, :path => "/m" do
    root :to => 'dashboard#show'
    resources :quotes, :only => [] do
      resource :invoice, :only => [:show, :edit, :update] do
        post "sign"
        post 'email'
      end
      resource :report, :only => [:show, :edit, :update] do
        post "sign"
      end
      member do
        post "sign"
        get 'terms'
      end
    end
  end
end
