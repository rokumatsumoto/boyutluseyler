RSpec.configure do |config|
  # https://github.com/teamcapybara/capybara#transactions-and-database-setup
  # Since Rails 5.1., we can force the application server and capybara to share the same connection,
  # which results in database_cleaner no longer being necessary.
  # This will only work with a server that works in single mode (e.g., Puma)
  # If you are using database_cleaner in cucumber, you can use it to ensure you run
  # with a clean database (which use_transactional_fixtures does not ensure).
  config.use_transactional_fixtures = true

  # OPTIMIZE
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end
end
