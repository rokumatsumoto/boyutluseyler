# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.

require './spec/simplecov_env'
SimpleCovEnv.start!

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'shoulda/matchers'
# TODO: Activate when they are needed
# require 'pundit/matchers'
# require 'pundit/rspec'

# Check for pending migrations before tests are run
ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Requires helpers, and shared contexts/examples first since they're used in other support files
Dir[Rails.root.join('spec/support/helpers/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/shared_contexts/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/shared_examples/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include WaitForRequests, :js
  config.include PageReload, :js
  config.include LoginHelpers, type: :feature
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include AbstractController::Translation

  # TODO: Activate when it is needed
  # config.before(:suite) do
  #   Timecop.safe_mode = true
  # end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 2

  config.filter_run_excluding tag: lambda { |tag|
    case tag
    when :devise_default
      # Always run :devise_default tests on CI. Only run locally if RUN_DEVISE_DEFAULT_TESTS
      !ENV['CI'] && !ENV['RUN_DEVISE_DEFAULT_TESTS']
    else
      false
    end
  }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
