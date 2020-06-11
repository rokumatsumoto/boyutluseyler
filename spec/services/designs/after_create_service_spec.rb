# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Designs::AfterCreateService do
  def after_create_design
    described_class.new(design, user, params).execute
  end

  shared_examples 'does not call services' do
    it 'does not move design files' do
      expect(design_files_move_service).not_to have_received(:execute)
    end

    it 'does not set design download step to not ready' do
      expect(design_download_create_service).not_to have_received(:execute)
    end
  end

  describe '#execute' do
    let(:design) { instance_double(Design) }
    let(:user) { instance_double(User) }
    let(:params) { { param1: 'value' } }

    let(:design_files_move_service) { instance_double(Designs::Files::MoveService) }
    let(:design_download_create_service) { instance_double(Designs::Downloads::CreateService) }

    before do
      allow(Designs::Files::MoveService).to receive(:new)
        .with(design, user, params).and_return(design_files_move_service)
      allow(design_files_move_service).to receive(:execute)

      allow(Designs::Downloads::CreateService).to receive(:new)
        .with(design, user).and_return(design_download_create_service)
      allow(design_download_create_service).to receive(:execute)

      after_create_design
    end

    context 'with design and design params' do
      it 'moves design files' do
        expect(design_files_move_service).to have_received(:execute)
      end

      it 'sets design download step to not ready' do
        expect(design_download_create_service).to have_received(:execute)
      end
    end

    context 'without design' do
      let(:design) { nil }

      it_behaves_like 'does not call services'
    end

    context 'without design params' do
      let(:params) { {} }

      it_behaves_like 'does not call services'
    end
  end
end
