# frozen_string_literal: true

module Users
  module Avatars
    class InitialsAvatarService
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def execute
        Boyutluseyler::FunctionCaller.new(function_name, payload).call
      end

      private

      def function_name
        'serverless-initials-avatar-dev-initials'
      end

      def payload
        {
          seed: user.username,
          filePath: file_path
        }
          .to_json
      end

      def file_path
        [
          'uploads',
          'user',
          'avatar-file',
          user.id,
          "#{SecureRandom.uuid}.#{output_format}"
        ].join('/')
      end

      def output_format
        'png'
      end
    end
  end
end
