require 'aws-sdk-s3'

aws_credentials = Aws::Credentials.new(
  Boyutluseyler.credentials[:aws_s3][:access_key_id],
  Boyutluseyler.credentials[:aws_s3][:secret_access_key]
)

S3_BUCKET = Aws::S3::Resource.new(
  region: Boyutluseyler.credentials[:aws_s3][:region],
  credentials: aws_credentials
).bucket(Boyutluseyler.credentials[:aws_s3][:bucket_name])

# S3_CLIENT = Aws::S3::Client.new(
#   region: Boyutluseyler.credentials[:aws_s3][:region],
#   credentials: aws_credentials
# )
