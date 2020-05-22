# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Illustrations::CreateFromDirectUploadService do
  let(:params) { { key: 'image.jpg' } }
  let(:user) { build_stubbed(:user) }
  let(:bucket) { instance_double(ObjectStorage::DirectUpload::Bucket) }
  let(:service) { described_class.new(bucket, user, params) }

  describe '#execute' do
    context 'when the remote object exists' do
      context 'with a valid remote object' do
        before do
          # rubocop:disable RSpec/VerifiedDoubles
          # stubbing Aws::S3::Object
          remote_object = double(key: 'image.jpg', size: 1, content_type: 'image/jpeg',
                                 public_url: 'http://foo.com/image.jpg', exists?: true)
          # rubocop:enable RSpec/VerifiedDoubles
          allow(bucket).to receive(:object).and_return(remote_object)
        end

        it 'creates the illustration and returns success' do
          response = service.execute

          expect(response[:status]).to eq(:success)
          expect(response[:illustration]).to be_an_instance_of Illustration
        end

        it 'builds URL for different sized illustrations' do
          response = service.execute
          illustration = response[:illustration]

          expect(illustration.large_url).to include('image_large.jpg')
          expect(illustration.medium_url).to include('image_medium.jpg')
          expect(illustration.thumb_url).to include('image_thumb.jpg')
        end
      end

      context 'with an invalid remote object' do
        it 'returns an error' do
          # rubocop:disable RSpec/VerifiedDoubles
          remote_object = double(key: 'image.tiff', size: 1, content_type: 'image/tiff',
                                 public_url: 'http://foo.com/image.tiff', exists?: true)
          # rubocop:enable RSpec/VerifiedDoubles
          allow(bucket).to receive(:object).and_return(remote_object)

          response = service.execute

          expect(response[:status]).to eq(:error)
          expect(response[:message]).not_to be_empty
        end
      end
    end

    context 'when the remote object is not exist' do
      it 'returns an error' do
        remote_object = double(:remote_object, exists?: false) # rubocop:disable RSpec/VerifiedDoubles
        allow(bucket).to receive(:object).and_return(remote_object)

        response = service.execute

        expect(response).to include(status: :error, message: 'File not found')
      end
    end
  end
end
