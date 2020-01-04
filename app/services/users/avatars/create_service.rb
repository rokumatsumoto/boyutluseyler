# frozen_string_literal: true

module Users
  module Avatars
    class CreateService < Users::BaseService
      def execute
        before_create

        user_avatar = BuildService.new(user, nil, params).execute

        success = user_avatar.save

        after_create if success

        user_avatar
      end

      private

      def before_create
        create_initials_avatar
      end

      def after_create
        Users::UpdateService.new(nil, user: user).execute
      end

      def create_initials_avatar
        url = InitialsAvatarService.new(user).execute

        params[:avatar_url] = url
        user.avatar_url = url
      end
    end
  end
end
