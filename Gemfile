source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
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
# Forms
gem 'client_side_validations', '~> 15.0'
gem 'client_side_validations-simple_form', '~> 7.0'
gem 'simple_form', '~> 4.1'

# Clean URL (https://en.wikipedia.org/wiki/Clean_URL)
gem 'friendly_id', '~> 5.2', '>= 5.2.5'
# HAML
gem 'hamlit', '~> 2.9', '>= 2.9.2'
# Spam and anti-bot protection
gem 'recaptcha', '~> 4.14'

# Catch unsafe migrations at dev time
gem 'strong_migrations', '~> 0.3.1'

gem 'local_time', '~> 2.1'

gem 'webpacker', '~> 4.0', '>= 4.0.2'

gem 'aws-sdk-s3', '~> 1.43'

gem 'gutentag', '~> 2.5', '>= 2.5.1'

gem 'mini_mime', '~> 1.0', '>= 1.0.1'

gem 'acts_as_list', '~> 0.9.19'

gem 'sanitize', '~> 5.0'

gem 'fast_jsonapi', '~> 1.5'

group :development, :test do
  # n+1 Queries
  gem 'bullet', '~> 5.9'
  gem 'pry-byebug', '~> 3.6', platform: :mri
  # call `rails r pry-rails` instead `rails console r pry-rails`
  gem 'pry-rails', '~> 0.3.9', require: false
  # Formatter
  gem 'fivemat', '~> 1.3', '>= 1.3.7'
  # RSpec BDD & TDD
  # see /spec/support/db_cleaner.rb, /lib/tasks/factory_bot_lint.rake
  gem 'database_cleaner', '~> 1.7', require: false
  gem 'factory_bot_rails', '~> 5.0'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  # gem 'vcr', '~> 4.0'
  # gem 'rspec_profiling', '~> 0.0.5'
  # gem 'rspec-set', '~> 0.1.3'
  gem 'bundler-audit', '~> 0.6.1', require: false
  gem 'parallel_tests', '~> 2.7', '>= 2.7.1'
  # gem 'rspec-parameterized', '~> 0.4.1', require: false
  gem 'rspec-parameterized', '~> 0.4.2', require: false
  gem 'simplecov', '~> 0.16.1', require: false

  # Lints
  # gem 'rubocop', '~> 0.63.1', require: false
  gem 'rubocop', '~> 0.73.0', require: false
  gem 'rubocop-rspec', '~> 1.34', require: false
  # gem 'rubocop-rspec', '~> 1.32', require: false

  gem 'haml_lint', '~> 0.28.0', require: false

  # Handle events on file system modifications.
  gem 'guard', '~> 2.15'
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false
  gem 'guard-rubocop', '~> 1.3', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'guard-annotate', '~> 2.3'
  gem 'letter_opener_web', '~> 1.3', '>= 1.3.4'
  gem 'meta_request', '~> 0.6.0'

  # Security
  gem 'guard-brakeman', '~> 0.8.3', require: false
  # Activate this gem when you need to hamlit:erb2haml rake task.
  # gem 'html2haml', '~> 2.2'
  # Provides hamlit generators for Rails 4. It also enables hamlit as the templating
  # engine and "hamlit:erb2haml" rake task that converts erb files to haml.
  gem 'hamlit-rails', '~> 0.2.0', require: false
end

group :test do
  gem 'pundit-matchers', '~> 1.6'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '4.0.0.rc1', require: false
  gem 'timecop', '~> 0.9.1'
  gem 'zonebie', '~> 0.6.1'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.13', '>= 3.13.2'
  gem 'capybara-email', '~> 3.0', '>= 3.0.1'
  gem 'capybara-screenshot', '~> 1.0', '>= 1.0.22'
  gem 'selenium-webdriver'
  # Easy installation and use of selenium webdriver browsers to run system tests
  gem 'webdrivers', '~> 4.1', '>= 4.1.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
