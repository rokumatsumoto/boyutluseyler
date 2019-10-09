# frozen_string_literal: true

module Designs
  module Files
    class DownloadService < Designs::BaseService
      def execute
        url_path = Boyutluseyler::FunctionCaller.new(function_name, payload).call
        archive_url(url_path)
      end

      private

      def function_name
        'aws-node-s3-zipper-stage-s3Zipper'
      end

      def payload
        {
          keys: blueprint_url_path_list,
          archiveFolderPath: archive_folder_path,
          archiveFilePath: archive_file_path,
          archiveFormat: archive_format
        }
          .to_json
      end

      def blueprint_url_path_list
        design.blueprints.pluck(:url_path)
      end

      def archive_folder_path
        [
          current_user.username,
          design.slug
        ].join('/')
      end

      def archive_file_path
        [
          'uploads',
          'design_zip',
          'file',
          current_user.id,
          archive_file_name
        ].join('/')
      end

      def archive_file_name
        "#{design.slug}#{last_updated_date_of_blueprints}-#{random_string}.#{archive_format}"
      end

      def last_updated_date_of_blueprints
        design.blueprints.pluck(:created_at).max.strftime('%Y%m%d')
      end

      def random_string
        [*('a'..'z'), *('0'..'9')].sample(8).join
      end

      def archive_format
        'zip'
      end

      def archive_url(url_path)
        # TODO: Add new config name
        "#{Boyutluseyler.config[:direct_upload_website_endpoint]}/#{url_path}"
      end
    end
  end
end
