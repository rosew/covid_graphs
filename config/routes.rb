Rails.application.routes.draw do
  resources :graphs, only: [ :show ]
end
