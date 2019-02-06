require 'capybara/rspec'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'selenium-webdriver'

## Configure capybara

# If using Rails 5.0+, but not using the Rails system tests from 5.1, you'll
# probably also want to swap the "server" used to launch your app to Puma in
# order to match Rails defaults.
# To clean up your test output
Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox]
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome
Capybara.default_max_wait_time = 5

## Configure capybara-screenshot

# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run
# From https://github.com/mattheworiordan/capybara-screenshot/issues/84#issuecomment-41219326
Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end
