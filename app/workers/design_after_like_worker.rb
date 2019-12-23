# frozen_string_literal: true

class DesignAfterLikeWorker
  include ApplicationWorker

  def perform(design_id, current_user_id, visit_token)
    design = Design.find(design_id)
    current_user = User.find(current_user_id)

    Designs::Likes::AfterLikeService.new(design, current_user, visit_token: visit_token).perform
  end
end
