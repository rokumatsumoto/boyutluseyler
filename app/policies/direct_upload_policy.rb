# frozen_string_literal: true

class DirectUploadPolicy < Struct.new(:user, :direct_upload)
  def initialize(*)
    super
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user
  end

  def new?
    user
  end
end
