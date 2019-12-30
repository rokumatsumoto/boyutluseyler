# frozen_string_literal: true

module Users
  class UpdateAvatarService
    attr_accessor :user
    def initialize(user)
      @user = user
    end

    def execute
      user.avatar_thumb_url = url_for_size(:thumb)
      user.avatar_url = url_for_size(:medium)

      user
    end

    private

    def url_for_size(size)
      Boyutluseyler::UrlBuilder.build(User.new,
                                      url: processed_public_url,
                                      suffix: "_#{size}")
    end

    def processed_public_url
      "#{Boyutluseyler.config[:direct_upload_processed_endpoint]}/#{user.avatar_url}"
    end

  end
end
