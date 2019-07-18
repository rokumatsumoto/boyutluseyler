require 'aws-sdk-s3'

aws_credentials = Aws::Credentials.new(
  Rails.application.credentials.aws_s3[:access_key_id],
  Rails.application.credentials.aws_s3[:secret_access_key]
)

S3_BUCKET = Aws::S3::Resource.new(
  region: Rails.application.credentials.aws_s3[:region],
  credentials: aws_credentials
).bucket(Rails.application.credentials.aws_s3[:bucket_name])

# S3_CLIENT = Aws::S3::Client.new(
#   region: Rails.application.credentials.aws_s3[:region],
#   credentials: aws_credentials
# )
