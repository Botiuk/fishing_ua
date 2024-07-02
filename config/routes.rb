Rails.application.routes.draw do
  devise_for :users

  get 'water_bioresources/statistic', to: 'water_bioresources#statistic'
  get 'fishing_places/statistic', to: 'fishing_places#statistic'
  get 'tools/statistic', to: 'tools#statistic'
  get 'main/statistic', to: 'main#statistic'

  resources :water_bioresources, except: :destroy
  resources :rate_penalties, except: :show
  resources :catch_rates, except: :show
  resources :fishing_places, except: [:show, :destroy]
  resources :tools, except: :show
  resources :fishing_sessions, except: :destroy
  resources :catches, except: [:edit, :destroy]
  resources :day_rates, except: :show
  resources :tool_catches, only: [:new, :create, :destroy]
 
  root "main#index"
end
