# frozen_string_literal: true

class AhoyEventService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def track
    ahoy = Ahoy::Tracker.new(
      user: params[:current_user],
      visit_token: params[:visit_token]
    )

    ahoy.track(params[:event_name], params[:properties])
  end
end
