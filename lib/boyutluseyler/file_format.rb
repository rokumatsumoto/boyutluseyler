# frozen_string_literal: true

module Boyutluseyler
  module FileFormat
    def file_format_for_collection_ids(collection_ids, collection_model)
      file_formats = Set.new

      collection_ids.each do |id|
        record = collection_model.find_by(id: id)

        next if record.nil?

        file_formats << extension_by_content_type(record.content_type).downcase
      end

      file_formats.to_a.join(', ')
    end

    private

    def extension_by_content_type(content_type)
      Boyutluseyler::MimeUtil.extension_by_content_type(content_type)
    end
  end
end
