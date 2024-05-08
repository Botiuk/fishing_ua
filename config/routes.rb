Rails.application.routes.draw do
  devise_for :users

  resources :water_bioresources, except: [:show, :destroy]
 
  root "main#index"
end
