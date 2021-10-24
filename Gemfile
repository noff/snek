source 'http://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.1'

gem 'coffee-script', '~> 2.4', '>= 2.4.1'

gem 'activeadmin'
gem 'aasm'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.1.3'
gem 'cancan'
gem 'devise'
gem 'draper'
gem 'execjs', '2.7.0'
gem 'gon', '~> 6.2.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'oj', '~> 2.16.1'
gem 'pg'
gem 'puma'
gem 'pundit'
# gem 'rails', '~> 5.2.0'
gem 'rails', '~> 5.2.6'
gem 'rollbar'
# gem 'sass-rails'
gem 'sassc-rails'
gem 'simple_form'
gem 'slim-rails'
# gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '~> 4.9.0'
gem 'sidekiq'
gem 'rmagick'
gem 'stripe'
gem 'whenever', require: false
gem 'ahoy_matey'
gem 'maxminddb'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'




group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.7'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-sidekiq'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
