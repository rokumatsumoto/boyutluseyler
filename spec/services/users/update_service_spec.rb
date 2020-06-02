# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Users::UpdateService do
  describe '#execute' do
    context 'when skip_confirmation parameter is true' do
      let(:user) { build(:user, :unconfirmed) }
      let(:params) do
        { skip_confirmation: true }
      end

      it 'confirms the user' do
        update_user(user, params)

        expect(user).to be_confirmed
      end
    end

    def update_user(user, opts)
      described_class.new(user, opts.merge(user: user)).execute
    end
  end
end
