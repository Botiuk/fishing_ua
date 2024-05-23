Rails.application.routes.draw do
  devise_for :users

  resources :water_bioresources, except: [:show, :destroy]
  resources :rate_penalties, except: :show
  resources :catch_rates, except: :show
  resources :fishing_places, except: [:show, :destroy]
  resources :tools, except: :show
 
  root "main#index"
end
