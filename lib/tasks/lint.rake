# frozen_string_literal: true

unless Rails.env.production?
  namespace :lint do
    desc 'boyutluseyler | lint | Lint HAML files'
    task :haml do
      Rake::Task['haml_lint'].invoke
    rescue RuntimeError # The haml_lint tasks raise a RuntimeError
      exit(1)
    end
    desc 'boyutluseyler | lint | Verify that all FactoryBot factories are valid'
    task :factory_bot do
      Rake::Task['factory_bot_lint'].invoke
    rescue RuntimeError # The factory_bot_lint tasks raise a RuntimeError
      exit(1)
    end
  end
end
