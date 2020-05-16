# frozen_string_literal: true

module ValidatesRemoteObject
  ValidationError = Class.new(StandardError)

  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#exists%3F-instance_method
  delegate :exists?, to: :remote_object, prefix: true

  def remote_object
    @remote_object ||= bucket.object(key)
  end
end
