# frozen_string_literal: true

module Boyutluseyler
  class FilenameHelper
    class << self
      # input: filename.jpg
      # output: filename
      def filename(name)
        return nil if name.blank?

        File.basename(name, '.*').split('.')[0]
      end

      # input: filename.jpg
      # output: .jpg
      def extname(name)
        return nil if name.blank?

        File.extname(name)
      end
    end
  end
end
