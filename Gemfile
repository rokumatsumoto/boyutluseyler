# rubocop:disable LineLength
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Authentication
gem 'devise', '~> 4.5'
gem 'devise-i18n', '~> 1.7', '>= 1.7.1'
# Authorization
gem 'pundit', '~> 2.0', '>= 2.0.1'
# CSS & JS Framework
gem 'bootstrap', '~> 4.2', '>= 4.2.1'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
# Forms
gem 'simple_form', '~> 4.1'
# Icons
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
# Clean URL (https://en.wikipedia.org/wiki/Clean_URL)
gem 'friendly_id', '~> 5.2', '>= 5.2.5'
# HAML
gem 'hamlit', '~> 2.9', '>= 2.9.2'

group :development, :test do
  # n+1 Queries
  gem 'bullet', '~> 5.9'
  gem 'pry-byebug', '~> 3.6', platform: :mri
  # call `rails r pry-rails` instead `rails console r pry-rails`
  gem 'pry-rails', '~> 0.3.9', require: false
  # Formatter
  gem 'fivemat', '~> 1.3', '>= 1.3.7'
  # RSpec BDD & TDD
  gem 'database_cleaner', '~> 1.7'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  # gem 'vcr', '~> 4.0'
  # gem 'rspec_profiling', '~> 0.0.5'
  # gem 'rspec-set', '~> 0.1.3'
  gem 'rspec-parameterized', '~> 0.4.1', require: false
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'bundler-audit', '~> 0.6.1', require: false

  # Lints
  gem 'rubocop', '~> 0.63.1', require: false
  gem 'rubocop-rspec', '~> 1.32'

  gem 'haml_lint', '~> 0.28.0', require: false

  # Handle events on file system modifications.
  gem 'guard', '~> 2.15'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false
  gem 'guard-rubocop', '~> 1.3', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'annotate', '~> 2.7', '>= 2.7.4'
  gem 'letter_opener_web', '~> 1.3', '>= 1.3.4'
  gem 'meta_request', '~> 0.6.0'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8.0'

  # Security
  gem 'brakeman', '~> 4.4', require: false

  # Catch unsafe migrations at dev time
  gem 'strong_migrations', '~> 0.3.1'

  # Activate this gem when you need to hamlit:html2haml rake task.
  # gem 'html2haml', '~> 2.2'
  # Provides hamlit generators for Rails 4. It also enables hamlit as the templating
  # engine and "hamlit:html2haml" rake task that converts erb files to haml.
  # gem 'hamlit-rails', '~> 0.2.0'
end

group :test do
  gem 'shoulda-matchers', '4.0.0.rc1', require: false
  gem 'rails-controller-testing'
  gem 'pundit-matchers', '~> 1.6'
  gem 'timecop', '~> 0.9.1'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# rubocop:enable LineLength
