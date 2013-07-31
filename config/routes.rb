CincyForclosures::Application.routes.draw do
  resources :properties, only: :index

  root to: 'properties#index'
end
