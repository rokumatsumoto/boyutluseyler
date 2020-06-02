# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Designs::CreateService do
  def create_design(params)
    described_class.new(nil, user, params).execute
  end

  describe '#execute' do
    let(:after_create_service) { instance_double(Designs::AfterCreateService) }

    before do
      allow(Designs::AfterCreateService).to receive(:new).and_return(after_create_service)
      allow(after_create_service).to receive(:execute)
    end

    context 'with valid params' do
      include_context 'valid design create params'

      it 'returns a persisted design' do
        design = create_design(params)

        expect(design).to be_persisted
      end

      it 'calls design after create service' do
        create_design(params)

        expect(after_create_service).to have_received(:execute)
      end
    end

    context 'with invalid params' do
      include_context 'invalid design create params'

      it 'does not create a design' do
        design = create_design(params)

        expect(design).not_to be_persisted
      end

      it 'does not call design after create service' do
        create_design(params)

        expect(after_create_service).not_to have_received(:execute)
      end
    end
  end
end
