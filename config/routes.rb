Moving::Application.routes.draw do

  # match '/account' => 'accounts#edit', :as => 'account'
  # get "accounts/update"
  resource :account, :only => [:show, :update]
  
  devise_for :users 
  resources :users
  root :to => 'dashboard#show'
end
