# frozen_string_literal: true

class UserAfterCreateWorker
  include ApplicationWorker

  def perform(user_id)
    user = User.find(user_id)

    Users::AfterCreateService.new(user).perform
  end
end
