# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blueprints::CreateFromDirectUploadService do
  let(:params) { { key: 'model.stl' } }
  let(:user) { build_stubbed(:user) }
  let(:bucket) { instance_double(ObjectStorage::DirectUpload::Bucket) }
  let(:service) { described_class.new(bucket, user, params) }

  describe '#execute' do
    context 'when the remote object exists' do
      it 'creates the blueprint and returns success' do
        # rubocop:disable RSpec/VerifiedDoubles
        # stubbing Aws::S3::Object
        remote_object = double(key: 'model.stl', size: 1, content_type: 'model/stl',
                               public_url: 'http://foo.com/model.stl', exists?: true)
        # rubocop:enable RSpec/VerifiedDoubles
        allow(bucket).to receive(:object).and_return(remote_object)

        response = service.execute

        expect(response[:status]).to eq(:success)
        expect(response[:blueprint]).to be_an_instance_of Blueprint
      end

      context 'with an invalid remote object' do
        it 'returns an error' do
          # rubocop:disable RSpec/VerifiedDoubles
          remote_object = double(key: 'model.ogex', size: 1, content_type: 'model/vnd.opengex',
                                 public_url: 'http://foo.com/model.ogex', exists?: true)
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
