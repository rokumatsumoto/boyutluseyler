# == Schema Information
#
# Table name: design_blueprints
#
#  id           :bigint(8)        not null, primary key
#  design_id    :bigint(8)        not null
#  blueprint_id :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  position     :integer
#

require 'spec_helper'

RSpec.describe DesignBlueprint, type: :model do
  describe 'modules' do
    subject { described_class }

    context 'for Acts As List config' do
      subject(:design_blueprint) { described_class.new }

      it 'uses a column named position' do
        expect(design_blueprint.position_column).to eq('position')
      end

      it 'uses a scope named design_id' do
        expect(design_blueprint.scope_name).to eq(:design_id)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:design).inverse_of(:design_blueprints) }
    it { is_expected.to belong_to(:blueprint) }
  end
end
