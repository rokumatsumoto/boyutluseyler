require 'aws-sdk-s3'

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
end
