# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Resource.html
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html

# Stubbing the AWS SDK
# https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/stubbing.html
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ClientStubs.html
# https://aws.amazon.com/blogs/developer/advanced-client-stubbing-in-the-aws-sdk-for-ruby-version-3/
# https://stelligent.com/2016/04/14/using-stubs-for-the-aws-sdk-for-ruby-2/
# https://semaphoreci.com/community/tutorials/stubbing-the-aws-sdk

module StubAWSResponses
  def stub_direct_upload_bucket_object_is_not_exist
    DIRECT_UPLOAD_RESOURCE.client.stub_responses(:head_object,
                                                 status_code: 404,
                                                 headers: {},
                                                 body: '')
  end

  def stub_direct_upload_bucket_object_exists
    DIRECT_UPLOAD_RESOURCE.client.stub_responses(:head_object,
                                                 status_code: 200,
                                                 headers: {},
                                                 body: '')
  end
end
