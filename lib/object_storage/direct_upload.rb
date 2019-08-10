# frozen_string_literal: true

module ObjectStorage
  class DirectUpload
    include Boyutluseyler::Utils::StrongMemoize

    RemoteStoreError = Class.new(StandardError)

    attr_reader :provider, :provider_name

    def initialize(provider, provider_name)
      @provider = provider
      @provider_name = provider_name
    end

    def presigned_post
      case @provider_name
      when Providers::AWS.name.demodulize
        @provider.bucket.presigned_post(@provider.presigned_post_options)
      end
    end
  end
end
