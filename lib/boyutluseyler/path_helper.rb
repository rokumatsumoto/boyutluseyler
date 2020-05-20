# frozen_string_literal: true

module Boyutluseyler
  class PathHelper
    class << self
      def info(path, options = nil)
        return nil if path.blank?
        return specific_info(path, options).to_s if options

        info = {}

        info[:dirname_with_filename] = dirname_with_filename(path).to_s
        info[:dirname] = dirname(path).to_s
        info[:basename] = basename(path).to_s
        info[:filename] = filename(path).to_s
        info[:extension] = extension(path).to_s

        info
      end

      def append_suffix_before_extension(path, suffix)
        parts = info(path)

        "#{parts[:dirname_with_filename]}#{suffix}#{parts[:extension]}"
      end

      private

      def specific_info(path, options)
        self.__send__(options, path)
      end

      # input: /path/to/filename.jpg
      # output: /path/to/filename
      def dirname_with_filename(path)
        Pathname(path).sub_ext('')
      end

      # input: /path/to/filename.jpg
      # output: /path/to
      def dirname(path)
        Pathname(path).dirname
      end

      # input: /path/to/filename.jpg
      # output: filename.jpg
      def basename(path)
        Pathname(path).basename
      end

      # input: /path/to/filename.jpg
      # output: filename
      def filename(path)
        return nil if path.starts_with?('.')

        Pathname(path).basename.sub_ext('')
      end

      # input: /path/to/filename.jpg
      # output: .jpg
      def extension(path)
        Pathname(path).extname
      end
    end
  end
end
