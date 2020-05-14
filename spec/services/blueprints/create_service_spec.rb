# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blueprints::CreateService do
  let(:params) { { key: 'model.stl' } }
  let(:user) { build_stubbed(:user) }
  let(:service) { described_class.new(user, params) }

  describe '#execute' do
    it 'creates the blueprint and returns success' do
      # rubocop:disable RSpec/VerifiedDoubles
      # stubbing Aws::S3::Object
      remote_object = double(key: 'model.stl', size: 1, content_type: 'model/stl',
                             public_url: 'http://foo.com/model.stl', exists?: true)
      # rubocop:enable RSpec/VerifiedDoubles
      stub_direct_upload_bucket_object(remote_object)

      response = service.execute

      expect(response[:status]).to eq(:success)
      expect(response[:blueprint]).to be_an_instance_of Blueprint
    end

    context 'when blueprint is invalid' do
      it 'returns an error' do
        # rubocop:disable RSpec/VerifiedDoubles
        # stubbing Aws::S3::Object
        remote_object = double(key: 'model.ogex', size: 1, content_type: 'model/vnd.opengex',
                               public_url: 'http://foo.com/model.ogex', exists?: true)
        # rubocop:enable RSpec/VerifiedDoubles
        stub_direct_upload_bucket_object(remote_object)

        response = service.execute

        expect(response[:status]).to eq(:error)
        expect(response[:message]).not_to be_empty
      end
    end

    context 'when the remote object is not exist' do
      before do
        stub_direct_upload_bucket_object_is_not_exist
      end

      after do
        stub_direct_upload_bucket_object_exists # default stub behavior
      end

      it 'returns an error' do
        response = service.execute

        expect(response).to include(status: :error, message: 'File not found')
      end
    end
  end
end
