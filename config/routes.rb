Rails.application.routes.draw do
  get "/captions", to: "captions#index"
  get "/captions/instagrams", to: "instagram_captions#index"
  get "/captions/:id", to: "captions#show"

  post "/captions", to: "captions#create"
  post "/captions/instagram", to: "instagram_captions#create"

  delete "/captions/:id", to: "captions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end
