# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get 'admin/users/search', to: 'users#search'
  scope '/admin' do
    resources :users, only: %i[index update]
  end

  get 'water_bioresources/statistic', to: 'water_bioresources#statistic'
  get 'fishing_places/statistic', to: 'fishing_places#statistic'
  get 'tools/statistic', to: 'tools#statistic'
  get 'main/statistic', to: 'main#statistic'
  get 'main/about', to: 'main#about'

  resources :water_bioresources, except: :destroy
  resources :rate_penalties, except: :show
  resources :catch_rates, except: :show
  resources :fishing_places, except: %i[show destroy]
  resources :tools, except: :show
  resources :fishing_sessions, except: :destroy
  resources :catches, except: :edit
  resources :day_rates, except: :show
  resources :tool_catches, only: %i[new create destroy]
  resources :news_stories

  root 'main#index'
end
