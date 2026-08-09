source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "bcrypt", "~> 3.1"
gem "mini_magick", "~> 5.3"
gem "dry-validation", "~> 1.11"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

gem "thruster", require: false

gem "image_processing", "~> 2.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "bundler-audit", require: false

  gem "brakeman", require: false

  gem "rubocop"

  gem "rubocop-rails-omakase", require: false

  gem "rubocop-rspec", require: false

  gem "rspec-rails", "~> 8.0"
end
