Rails.application.routes.draw do
  resources :references
  resources :big_cards
  resources :espy_records
  resources :icpsr_records
  resources :index_cards
  get "/make" => "espy_records#make"
  get "/index_cards/:state", to: "index_cards#index", as: "state"
  get "/icpsr_records/:limit", to: "icpsr_records#index", as: "limit"
  get "/link_big_cards" => "big_cards#link"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

end
