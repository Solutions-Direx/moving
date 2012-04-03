Moving::Application.routes.draw do
  devise_for :users 
  resources :users
  root :to => 'dashboard#show'
end
