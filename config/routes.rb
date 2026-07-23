Rails.application.routes.draw do
  get "/captions", to: "captions#index"
  get "/captions/:id", to: "captions#show"
  post "/captions", to: "captions#create"
  delete "/captions/:id", to: "captions#destroy"

  post "/memes", to: "memes#create"
  get "/memes/:file",
      to: "memes#show",
      as: :meme,
      format: false,
      constraints: { file: %r{[^/]+} }

  post "/signup", to: "users#signup"
  post "/login", to: "users#login"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
