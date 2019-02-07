# frozen_string_literal: true

unless Rails.env.production?
  desc 'boyutluseyler | convert | Convert erb to haml in app/views'
  task :erb2haml do
    Rake::Task['hamlit:erb2haml'].invoke
  rescue RuntimeError # The hamlit:erb2haml tasks raise a RuntimeError
    exit(1)
  end
end
