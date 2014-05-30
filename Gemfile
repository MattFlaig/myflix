source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'coffee-rails'
gem 'rails', '~> 4.0.0'
gem 'haml-rails'
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier'
gem 'jquery-rails'
gem 'sidekiq'


group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
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
end

group :test do
	gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
end