# frozen_string_literal: true

module UsersHelper
  def liked_design?(design_id)
    return false unless current_user

    Ahoy::Event.cached_any_events_for?(Ahoy::Event::LIKED_DESIGN,
                                       current_user,
                                       design_id: design_id)
  end
end
