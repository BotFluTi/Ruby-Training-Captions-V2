Rails.application.routes.draw do
  get "/captions", to: "captions#index"
  get "/captions/:id", to: "captions#show"
  post "/captions", to: "captions#create"
  delete "/captions/:id", to: "captions#destroy"

  post "/signup", to: "users#signup"
  post "/login", to: "users#login"

  get "up" => "rails/health#show", as: :rails_health_check
end
