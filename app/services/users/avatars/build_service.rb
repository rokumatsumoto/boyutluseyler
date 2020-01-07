# frozen_string_literal: true

module Users
  module Avatars
    class BuildService < Users::BaseService
      def execute
        UserAvatar.new.tap do |ua|
          ua.user = user
          ua.letter_avatar_url = url_for_size(:medium)
          ua.letter_avatar_thumb_url = url_for_size(:thumb)
        end
      end

      private

      def url_for_size(size)
        Boyutluseyler::UrlBuilder.build(UserAvatar.new,
                                        url: processed_public_url,
                                        suffix: "_#{size}")
      end

      def processed_public_url
        "#{Boyutluseyler.config[:processed_endpoint]}/#{params[:avatar_url]}"
      end
    end
  end
end
