# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"
gem "image_processing", "1.9.3"
gem "mini_magick"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.2"
# Hash function
gem "bcrypt", "3.1.13"
# Generate fake data
gem "active_storage_validations", "0.8.9"
gem "faker", "2.11.0"
gem "rubocop-performance"
# Pagination gem
gem "bootstrap-will_paginate", "1.0.0"
gem "will_paginate", "3.3.0"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Use boot-strap
gem "bootstrap-sass", "3.4.1"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem "rubyzip"
gem "axlsx"
gem "caxlsx_rails"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
gem "rubocop", "0.71", require: false
# Google Authen
gem "dotenv-rails"
gem "figaro"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
# il8n
gem "rails-i18n"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i(mri mingw x64_mingw)
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "pry-rails"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "minitest-reporters", "~> 1.1", ">= 1.1.7"
  gem "rails-helper"
  gem "rspec-rails", "~> 4.0.1"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "webdrivers"
  # Template testing
  gem "rails-controller-testing"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
