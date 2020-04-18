# == Schema Information
#
# Table name: design_downloads
#
#  id         :bigint(8)        not null, primary key
#  step       :string(50)       not null
#  url        :string
#  design_id  :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

RSpec.describe DesignDownload, type: :model do
  # rubocop: disable RSpec/BeforeAfterAll
  before(:all) do
    described_class.state_machine_class = TestStateMachine
  end

  after(:all) do
    described_class.state_machine_class = nil
  end
  # rubocop: enable RSpec/BeforeAfterAll

  let(:steps) { TestStateMachine.steps.collect!(&:to_s) }
  let(:design_download) { create(:design_download) }
  let(:initial_step) { steps[0] }

  describe 'associations' do
    it { is_expected.to belong_to(:design) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:go_forward).to(:state_machine) }
    it { is_expected.to delegate_method(:current_step).to(:state_machine) }
    it { is_expected.to delegate_method(:set_step_as).to(:state_machine) }
    it { is_expected.to delegate_method(:rollback_to).to(:state_machine) }
    it { is_expected.to delegate_method(:previous_step?).to(:state_machine) }
    it { is_expected.to delegate_method(:previous_step).to(:state_machine) }
    it { is_expected.to delegate_method(:next_step).to(:state_machine) }
    it { is_expected.to delegate_method(:next_step?).to(:state_machine) }
    it { is_expected.to delegate_method(:state_machine_class).to(:state_machine) }
    it { is_expected.to delegate_method(:defined_steps).to(:state_machine) }
    it { is_expected.to delegate_method(:initial_step).to(:state_machine) }
    it { is_expected.to delegate_method(:go_back).to(:state_machine) }
    it { is_expected.to delegate_method(:go_back!).to(:state_machine) }
    it { is_expected.to delegate_method(:can?).to(:state_machine) }
  end

  describe 'intializing an instance' do
    context 'with a new instance' do
      it 'has the current step set as the initial step' do
        expect(design_download.current_step).to eq(initial_step)
      end
    end

    context 'with a saved instance' do
      let(:design_download) { create(:design_download, step: steps[1]) }

      it 'has current step matching the saved step' do
        expect(design_download.current_step).to eq(steps[1])
      end
    end
  end

  describe '.go_forward' do
    it 'does not preserve the current step without save' do
      design_download.go_forward

      design_download.reload

      expect(design_download.step).to eq(initial_step)
    end
  end

  describe '.set_step_as' do
    context 'with valid step' do
      let(:new_step) { steps[2] }

      before do
        design_download.set_step_as new_step
      end

      it 'changes the current step to the new step' do
        expect(design_download.current_step).to eq(new_step)
      end

      it 'does not preserve the change' do
        design_download.reload

        expect(design_download.step).to eq(initial_step)
      end

      it 'preserves the change if saved' do
        design_download.save

        expect(design_download.step).to eq(new_step)
      end
    end

    context 'with unknown step' do
      let(:new_step) { 'unknown' }

      it 'makes the design download invalid' do
        design_download.set_step_as new_step

        expect(design_download.invalid?).to eq(true)
        expect(design_download.errors.include?(:step)).to eq(true)
      end
    end
  end
end
