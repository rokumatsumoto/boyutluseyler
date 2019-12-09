# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks
Rake::Task['default'].clear

task default: 'bundler:audit'
# TODO: add brakeman, rails-best-practices, Rubocop, reek v.s to default task
