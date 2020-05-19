# frozen_string_literal: true

module Boyutluseyler
  class PathHelper
    class << self
      def info(path, options = nil)
        return specific_info(path, options) if options

        info = {}

        info[:dirname_with_filename] = dirname_with_filename(path)
        info[:basename] = basename(path)
        info[:filename] = filename(path)
        info[:extension] = extension(path)

        info
      end

      def append_suffix_before_extension(path, suffix)
        parts = info(path)

        "#{parts[:dirname_with_filename]}#{suffix}#{parts[:extension]}"
      end

      private

      def specific_info(path, options)
        return send(options, path) if options&.is_a?(Symbol) && respond_to?(options, true)

        raise NotImplementedError,
              "#{name} does not implement #{options}"
      end

      # input: /path/to/filename.jpg
      # output: /path/to/filename
      def dirname_with_filename(path)
        return nil if path.blank?

        "#{dirname(path)}/#{filename(path)}"
      end

      # input: /path/to/filename.jpg
      # output: /path/to
      def dirname(path)
        return nil if path.blank?

        File.dirname(path)
      end

      # input: /path/to/filename.jpg
      # output: filename.jpg
      def basename(path)
        return nil if path.blank?

        File.basename(path)
      end

      # input: /path/to/filename.jpg
      # output: filename
      def filename(path)
        return nil if path.blank?

        File.basename(path, '.*').split('.')[0]
      end

      # input: /path/to/filename.jpg
      # output: .jpg
      def extension(path)
        return nil if path.blank?

        File.extname(path)
      end
    end
  end
end
