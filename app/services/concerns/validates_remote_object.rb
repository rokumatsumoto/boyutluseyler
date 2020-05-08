# frozen_string_literal: true

module ValidatesRemoteObject
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#exists%3F-instance_method
  delegate :exists?, to: :remote_object, prefix: true

  def remote_object
    @remote_object ||= bucket.object(key)
  end

  def bucket
    super || (raise NotImplementedError,
                    '"bucket" must be implemented and return an Aws::S3::Bucket')
  end

  def key
    params[:key] || (raise ArgumentError, 'Key needs to be specified')
  end
end
