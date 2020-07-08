if Boyutluseyler.config[:direct_upload_provider] == 'AWS'

  if (Boyutluseyler.config[:direct_upload_access_key_id] != nil &&
      Boyutluseyler.config[:direct_upload_secret_access_key] != nil)

    credentials = Aws::Credentials.new(
      Boyutluseyler.config[:direct_upload_access_key_id],
      Boyutluseyler.config[:direct_upload_secret_access_key]
    )

    # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Resource.html
    DIRECT_UPLOAD_RESOURCE = Aws::S3::Resource.new(
      stub_responses: Rails.env.test?,
      region: Boyutluseyler.config[:direct_upload_region],
      credentials: credentials
    )

    DIRECT_UPLOAD_BUCKET = DIRECT_UPLOAD_RESOURCE.bucket(Boyutluseyler.config[:direct_upload_bucket_name])

    DIRECT_UPLOAD_AWS_S3_CLIENT = Aws::S3::Client.new(
      region: Boyutluseyler.config[:direct_upload_region],
      credentials: credentials
    )
  end
end

if (Boyutluseyler.credentials[:aws_s3][:access_key_id] != nil &&
    Boyutluseyler.credentials[:aws_s3][:secret_access_key] != nil)

  s3_credentials = Aws::Credentials.new(
    Boyutluseyler.credentials[:aws_s3][:access_key_id],
    Boyutluseyler.credentials[:aws_s3][:secret_access_key]
  )

  AWS_S3_CLIENT = Aws::S3::Client.new(
    region: Boyutluseyler.credentials[:aws_s3][:region],
    credentials: s3_credentials
  )
end

if (Boyutluseyler.credentials[:aws][:access_key_id] != nil &&
    Boyutluseyler.credentials[:aws][:secret_access_key] != nil)

    AWS_LAMBDA = Aws::Lambda::Client.new(
      stub_responses: Rails.env.test?,
      region: Boyutluseyler.credentials[:aws][:region],
      access_key_id: Boyutluseyler.credentials[:aws][:access_key_id],
      secret_access_key: Boyutluseyler.credentials[:aws][:secret_access_key]
    )
end
