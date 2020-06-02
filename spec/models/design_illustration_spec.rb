# == Schema Information
#
# Table name: design_illustrations
#
#  id              :bigint(8)        not null, primary key
#  design_id       :bigint(8)        not null
#  illustration_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer
#

require 'spec_helper'

RSpec.describe DesignIllustration, type: :model do
  describe 'modules' do
    subject { described_class }

    context 'for Acts As List config' do
      subject(:design_illustration) { described_class.new }

      it 'uses a column named position' do
        expect(design_illustration.position_column).to eq('position')
      end

      it 'uses a scope named design_id' do
        expect(design_illustration.scope_name).to eq(:design_id)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:design).inverse_of(:design_illustrations) }
    it { is_expected.to belong_to(:illustration) }
  end
end
