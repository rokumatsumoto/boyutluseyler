# frozen_string_literal: true

module Boyutluseyler
  class FilenameHelpers
    # input: filename.jpg
    # output: filename
    def self.filename(name)
      return nil if name.blank?

      File.basename(name, '.*').split('.')[0]
    end

    # input: filename.jpg
    # output: .jpg
    def self.extname(name)
      return nil if name.blank?

      File.extname(name)
    end
  end
end
