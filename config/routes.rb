Rails.application.routes.draw do
  resources :icpsr_records
  resources :index_cards
  get "/index_cards/:state", to: "index_cards#index", as: "state"
  get "/icpsr_records/:limit", to: "icpsr_records#index", as: "limit"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
