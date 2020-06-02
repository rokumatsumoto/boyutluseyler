# frozen_string_literal: true

module Users
  module Avatars
    class BuildService < Users::BaseService
      def execute
        UserAvatar.new.tap do |ua|
          ua.user = user
          ua.letter_avatar_url = avatar_url_for_size(:medium)
          ua.letter_avatar_thumb_url = avatar_url_for_size(:thumb)
        end
      end

      private

      def avatar_url_for_size(size)
        Boyutluseyler::PathHelper.append_suffix_before_extension(processed_avatar_url, "_#{size}")
      end

      def processed_avatar_url
        "#{Boyutluseyler.config[:processed_endpoint]}/#{params[:avatar_url]}"
      end
    end
  end
end
