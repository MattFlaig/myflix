source 'https://rubygems.org'
ruby '2.0.0'

gem 'bcrypt'
gem 'coffee-rails'
gem 'rails', '~> 4.0.0'
gem 'haml-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'sidekiq'
gem 'figaro'
gem 'fog'
gem 'carrierwave'
gem 'mini_magick'
gem 'stripe'
gem 'stripe_event'
gem 'draper'
gem 'bootstrap-sass', '~> 2.2.1.0'
gem 'bootstrap_form'

group :assets do
  gem 'sass-rails', '~> 4.0.2'
  gem 'font-awesome-rails'
end


group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rb-readline', '~> 0.4.2'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'sentry-raven'
  gem 'paratrooper'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'fabrication'
  gem 'faker'
  gem 'letter_opener'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock', '1.11.0'
  gem 'selenium-webdriver', '2.39.0'
  gem 'database_cleaner', '1.2.0'
end