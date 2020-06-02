module StubDirectUploadBucket
  def stub_direct_upload_bucket_object(remote_object)
    direct_upload_bucket = stub_direct_upload_bucket

    allow(direct_upload_bucket).to receive(:object).and_return(remote_object)
  end

  def stub_direct_upload_bucket
    direct_upload_bucket = instance_double(ObjectStorage::DirectUpload::Bucket)

    allow(ObjectStorage::DirectUpload::Bucket).to receive(:new).and_return(direct_upload_bucket)

    direct_upload_bucket
  end
end
