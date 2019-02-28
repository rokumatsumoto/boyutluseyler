module CapybaraHelpers
  # Simulate a browser restart by clearing the session cookie.
  def clear_browser_session
    browser = page.driver.browser

    if browser.respond_to?(:set_cookie)
      # Rack::MockSession
      browser.set_cookie('_boyutluseyler_session')
    elsif browser.respond_to?(:manage)
      # Selenium::WebDriver
      browser.manage.delete_cookie('_boyutluseyler_session')
    else
      raise "Don't know how to clear cookies. Weird driver?"
    end
  end

  # rubocop:disable Lint/Debugger
  def down_the_rabbit_hole
    return if Capybara.current_driver == :rack_test

    puts current_url
    binding.pry
  end
  # rubocop:enable Lint/Debugger
end
