Rails.application.routes.draw do
  root 'icpsr_records#index'

  resources :references
  resources :big_cards
  resources :espy_records
  resources :icpsr_records
  resources :index_cards
  get "/make" => "espy_records#make"
  get "/index_cards/:state", to: "index_cards#index", as: "state"
  get "/icpsr_records/:limit", to: "icpsr_records#index", as: "limit"
  get "/link_big_cards" => "big_cards#link"
  get "/link_pdfs" => "references#link"
  get "/rotate" => "references#rotate"
  get "/reindex" => "icpsr_records#reindex"
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  match '/icpsr_records/:id/:ref', to: 'icpsr_records#remove_link', via: :delete
  match '/add_file', to: 'references#add_file', via: :put
  match '/remove_file', to: 'references#remove_file', via: :put
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

end
