Moving::Application.routes.draw do

  match '/account' => 'accounts#edit', :as => 'account'
  get "accounts/update"
  
  devise_for :users 
  resources :users
  root :to => 'dashboard#show'
end
