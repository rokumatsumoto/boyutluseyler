# frozen_string_literal: true

class AhoyWorker
  include ApplicationWorker

  def perform(options)
    current_user = User.find(options['current_user_id'])

    ahoy = Ahoy::Tracker.new(
      user: current_user,
      visit_token: options['visit_token']
    )

    ahoy.track(options['event_name'], properties(options))
  end

  private

  def properties(options)
    AhoyDataService.new(options).execute
  end
end
