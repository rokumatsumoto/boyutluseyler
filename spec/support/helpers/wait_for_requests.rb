module WaitForRequests
  extend self

  # Wait for client-side AJAX requests
  def wait_for_requests
    wait_for('JS requests complete', max_wait_time: 2 * Capybara.default_max_wait_time) do
      finished_all_js_requests?
    end
  end

  private

  def finished_all_js_requests?
    return true unless javascript_test?

    finished_all_ajax_requests?
  end

  # Waits until the passed block returns true
  def wait_for(condition_name, max_wait_time: Capybara.default_max_wait_time,
               polling_interval: 0.01)
    wait_until = Time.now + max_wait_time.seconds
    loop do
      break if yield

      raise "Condition not met: #{condition_name}" if Time.now > wait_until

      sleep(polling_interval)
    end
  end

  def finished_all_ajax_requests?
    return true if Capybara.page.evaluate_script('typeof jQuery === "undefined"')

    Capybara.page.evaluate_script('jQuery.active').zero?
  end

  def javascript_test?
    Capybara.current_driver == Capybara.javascript_driver
  end
end
