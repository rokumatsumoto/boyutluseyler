# frozen_string_literal: true

task :factory_bot_lint do
  if Rails.env.test?
    # FIXME: ActiveRecord::ConnectionNotEstablished:
    # No connection pool with 'primary' found.
    require 'database_cleaner'
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.cleaning do
      FactoryBot.lint
    end
  else
    system("bundle exec rake lint:factory_bot RAILS_ENV='test'")
    require 'English'
    raise if $CHILD_STATUS.exitstatus.nonzero?
  end
end
