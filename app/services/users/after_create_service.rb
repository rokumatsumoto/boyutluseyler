# frozen_string_literal: true

module Users
  class AfterCreateService
    attr_accessor :user
    def initialize(user)
      @user = user
    end

    def execute
      UserAfterCreateWorker.perform_async(user.id)
    end

    def perform
      set_initial_avatar
    end

    private

    def set_initial_avatar
      Users::Avatars::CreateService.new(user).execute
    end
  end
end
