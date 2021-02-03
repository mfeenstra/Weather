Rails.application.routes.draw do
  root to: 'locations#new'
  resources :locations
end
