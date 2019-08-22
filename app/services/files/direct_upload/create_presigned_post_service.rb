# frozen_string_literal: true

module Files
  module DirectUpload
    class CreatePresignedPostService
      attr_reader :model, :uploader_context

      def initialize(model, **uploader_context)
        @model = model
        apply_context!(uploader_context)
      end

      def execute
        direct_upload.presigned_post(obj_key_prefix, obj_content_length)
      end

      private

      def direct_upload
        ObjectStorage::DirectUpload.new(model)
      end

      def obj_key_prefix
        case model.name
        when Blueprint.name
          uploaders_key_prefix
        when Illustration.name
          uploaders_key_prefix
        end
      end

      def obj_content_length
        case model.name
        when Blueprint.name
          Blueprint.content_length_range
        when Illustration.name
          Illustration.content_length_range
        end
      end

      def uploaders_key_prefix
        [
          'uploaders',
          @current_user_id,
          "#{model.name.downcase}-file",
          SecureRandom.uuid
        ].join('/')
      end

      def apply_context!(uploader_context)
        @current_user_id = uploader_context.values_at(:current_user_id)
      end
    end
  end
end
