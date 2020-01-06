if Boyutluseyler.config[:direct_upload_provider] == 'AWS'
  credentials = Aws::Credentials.new(
    Boyutluseyler.config[:direct_upload_access_key_id],
    Boyutluseyler.config[:direct_upload_secret_access_key]
  )

  resource = Aws::S3::Resource.new(
    region: Boyutluseyler.config[:direct_upload_region],
    credentials: credentials
  )

  DIRECT_UPLOAD_AWS_S3_BUCKET = resource.bucket(Boyutluseyler.config[:direct_upload_bucket_name])

  DIRECT_UPLOAD_AWS_S3_CLIENT = Aws::S3::Client.new(
    region: Boyutluseyler.config[:direct_upload_region],
    credentials: credentials
  )
end

AWS_LAMBDA = Aws::Lambda::Client.new(
  stub_responses: Rails.env.test?,
  region: Boyutluseyler.credentials[:aws][:region],
  access_key_id: Boyutluseyler.credentials[:aws][:access_key_id],
  secret_access_key: Boyutluseyler.credentials[:aws][:secret_access_key]
)
