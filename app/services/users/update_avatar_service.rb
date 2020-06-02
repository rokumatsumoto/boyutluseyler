# frozen_string_literal: true

module Users
  class UpdateAvatarService
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def execute
      return oauth_avatar if oauth_avatar?

      user.avatar_thumb_url = avatar_url_for_size(:thumb)
      user.avatar_url = avatar_url_for_size(:medium)

      user
    end

    private

    def oauth_avatar?
      user.new_record? && user.external
    end

    def oauth_avatar
      Users::OAuthAvatarService.new(user).execute
    end

    def avatar_url_for_size(size)
      Boyutluseyler::PathHelper.append_suffix_before_extension(processed_avatar_url, "_#{size}")
    end

    def processed_avatar_url
      "#{Boyutluseyler.config[:processed_endpoint]}/#{user.avatar_url}"
    end
  end
end
