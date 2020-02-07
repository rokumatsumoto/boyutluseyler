# frozen_string_literal: true

source 'https://rubygems.org'

# Enforce git to transmitted via https.
# workaround until we upgrade bundler to 2.0
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.5'

gem 'activerecord-jsonb-associations', github: 'rokumatsumoto/activerecord-jsonb-associations', branch: 'master'
gem 'acts_as_list', '~> 0.9.19'
gem 'ahoy_matey', '~> 3.0', '>= 3.0.1'
gem 'aws-sdk-lambda', '~> 1.30'
gem 'aws-sdk-s3', '~> 1.48'
gem 'bootsnap', '~> 1.4', '>= 1.4.5', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'client_side_validations', '~> 16.0', '>= 16.0.2'
gem 'client_side_validations-simple_form', '~> 9.0'
gem 'counter_culture', '~> 2.2', '>= 2.2.4'
gem 'devise', '~> 4.7', '>= 4.7.1' # Authentication
gem 'devise-i18n', '~> 1.7', '>= 1.7.1'
gem 'down', '~> 5.1'
gem 'fast_jsonapi', '~> 1.5'
gem 'finite_machine', '~> 0.12.1'
gem 'friendly_id', '~> 5.3' # Clean URL
gem 'gon', '~> 6.2', '>= 6.2.1'
gem 'gutentag', '~> 2.5', '>= 2.5.1'
gem 'hamlit', '~> 2.9', '>= 2.9.2'
gem 'hiredis', '~> 0.6.3'
gem 'jbuilder', '~> 2.5'
gem 'local_time', '~> 2.1'
gem 'mini_mime', '~> 1.0', '>= 1.0.1'
gem 'omniauth', '~> 1.9'
gem 'omniauth-facebook', '~> 5.0'
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'omniauth-rails_csrf_protection', '~> 0.1.2' # remove once https://github.com/omniauth/omniauth/pull/809 is resolved
gem 'oj', '~> 3.9', '>= 3.9.2' # Speed up JSON processes
gem 'pagy', '~> 3.7' # Update pagy.js file also
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3', '>= 4.3.1'
gem 'pundit', '~> 2.0', '>= 2.0.1' # Authorization
gem 'rails', '5.2.3'
gem 'recaptcha', '~> 4.14' # Spam and anti-bot protection
gem 'redis', '~> 4.1', '>= 4.1.3', require: ['redis', 'redis/connection/hiredis']
gem 'sail', '~> 3.3'
gem 'sanitize', '~> 5.0'
# A portability issue in the sassc gem exists on several platforms.
# https://github.com/sass/sassc-ruby/issues/146
gem 'sassc', '2.1.0', require: false # TODO: Remove when we upgrade Rails to 6.0
gem 'sassc-rails', '~> 2.1', '>= 2.1.2' # TODO: Remove when we upgrade Rails to 6.0 https://github.com/rails/sass-rails/pull/424
gem 'sidekiq', '~> 5.2', '>= 5.2.7' # Background jobs
gem 'sidekiq-cron', '~> 1.1' # Cron jobs
gem 'simple_form', '~> 5.0' # Forms
gem 'strong_migrations', '~> 0.4.1' # Catch unsafe migrations at dev time
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.2'
# gem 'rack-cors', '~> 1.0', '>= 1.0.3'
# gem 'turkish_support', '~> 1.1', '>= 1.1.3'

group :development, :test do
  gem 'bullet', '~> 5.9' # n+1 Queries
  gem 'bundler-audit', '~> 0.6.1', require: false
  gem 'database_cleaner', '~> 1.7', require: false
  gem 'factory_bot_rails', '~> 5.0'
  gem 'faker', '~> 2.7'
  gem 'fivemat', '~> 1.3', '>= 1.3.7' # RSpec Formatter
  gem 'guard', '~> 2.15' # Handle events on file system modifications.
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false
  gem 'guard-rubocop', '~> 1.3', require: false
  gem 'haml_lint', '~> 0.28.0', require: false
  gem 'parallel_tests', '~> 2.30', '>= 2.30.1'
  gem 'pry-byebug', '~> 3.6', platform: :mri
  gem 'pry-rails', '~> 0.3.9', require: false # call `rails r pry-rails` instead `rails console r pry-rails`
  gem 'rspec-parameterized', '~> 0.4.2', require: false
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'rubocop', '~> 0.77.0', require: false
  gem 'rubocop-rails', '~> 2.4', require: false
  gem 'rubocop-rspec', '~> 1.34', require: false
  gem 'simplecov', '~> 0.17.1', require: false
  # gem 'vcr', '~> 4.0'
  # gem 'rspec_profiling', '~> 0.0.5'
  # gem 'rspec-set', '~> 0.1.3'
end

group :development do
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'guard-annotate', '~> 2.3'
  gem 'guard-brakeman', '~> 0.8.3', require: false # Security
  gem 'hamlit-rails', '~> 0.2.0', require: false # Provides hamlit generators for Rails 4. It also enables hamlit as the templating engine and "hamlit:erb2haml" rake task that converts erb files to haml.
  gem 'letter_opener_web', '~> 1.3', '>= 1.3.4'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'meta_request', '~> 0.6.0'
  gem 'rack-mini-profiler', '~> 1.1', '>= 1.1.6', require: false
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0' # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # Activate this gem when you need to hamlit:erb2haml rake task.
  # gem 'html2haml', '~> 2.2'
end

group :test do
  gem 'capybara', '~> 3.29' # Adds support for Capybara system testing and selenium driver
  gem 'capybara-email', '~> 3.0', '>= 3.0.1'
  gem 'capybara-screenshot', '~> 1.0', '>= 1.0.24'
  gem 'pundit-matchers', '~> 1.6'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.5'
  gem 'shoulda-matchers', '4.0.0.rc1', require: false
  gem 'timecop', '~> 0.9.1'
  gem 'webdrivers', '~> 4.1', '>= 4.1.2', require: false # Easy installation and use of selenium webdriver browsers to run system tests
  gem 'zonebie', '~> 0.6.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
