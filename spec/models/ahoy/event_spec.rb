# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint(8)        not null, primary key
#  visit_id   :bigint(8)
#  user_id    :bigint(8)
#  name       :string
#  properties :jsonb
#  time       :datetime
#

require 'spec_helper'

RSpec.describe Ahoy::Event, type: :model do
  describe 'modules' do
    subject { described_class }

    it { is_expected.to include_module(Ahoy::QueryMethods) }
  end

  describe 'constants' do
    subject { described_class }

    let(:viewed_design) { 'Viewed design' }
    let(:liked_design) { 'Liked design' }
    let(:downloaded_design) { 'Downloaded design' }
    let(:user_events) { [liked_design, downloaded_design] }

    it { is_expected.to have_constant(:VIEWED_DESIGN, String).with_value(viewed_design) }
    it { is_expected.to have_constant(:LIKED_DESIGN, String).with_value(liked_design) }
    it { is_expected.to have_constant(:DOWNLOADED_DESIGN, String).with_value(downloaded_design) }
    it { is_expected.to have_constant(:USER_EVENTS, Array).with_value(user_events) }
  end

  describe 'associations' do
    # https://github.com/rokumatsumoto/boyutluseyler/issues/105
    xit { is_expected.to belong_to(:visit) }
    xit { is_expected.to belong_to(:user).optional }
  end

  context 'when caching counters' do
    let(:user) { create(:user) }
    let(:design) { create(:design) }

    describe '#events_count' do
      it 'counts liked design event for user' do
        pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
        create_pair(:ahoy_event, :liked_design, user: user)

        expect(user.reload.events_count).to eq(2)
      end

      it 'counts downloaded design event for user' do
        pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
        create_pair(:ahoy_event, :downloaded_design, user: user)

        expect(user.reload.events_count).to eq(2)
      end

      it 'updates updated_at for the user' do
        pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
        updated_at = user.updated_at

        Timecop.travel(1.day.from_now) do
          create(:ahoy_event, :downloaded_design, user: user)

          expect(user.reload.updated_at).to be > updated_at
        end
      end
    end

    describe '#downloads_count' do
      it 'counts downloaded design event for design' do
        pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
        create_pair(:ahoy_event, :downloaded_design, properties: { design_id: design.id })

        expect(design.reload.downloads_count).to eq(2)
      end
    end

    describe '#likes_count' do
      it 'counts liked design event for design' do
        pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
        create_pair(:ahoy_event, :liked_design, properties: { design_id: design.id })

        expect(design.reload.likes_count).to eq(2)
      end
    end
  end

  # TODO: remove once https://github.com/rokumatsumoto/boyutluseyler/issues/105 is resolved
  describe '.user_event?' do
    it 'returns true for user events' do
      event_name = described_class::USER_EVENTS.sample

      expect(described_class.send(:user_event?, event_name)).to be true
    end

    it 'returns false for other events' do
      event_name = described_class::VIEWED_DESIGN

      expect(described_class.send(:user_event?, event_name)).to be false
    end
  end

  # TODO: remove once https://github.com/rokumatsumoto/boyutluseyler/issues/105 is resolved
  describe '.download_event?' do
    it 'returns true for download event' do
      event_name = described_class::DOWNLOADED_DESIGN

      expect(described_class.send(:download_event?, event_name)).to be true
    end

    it 'returns false for other events' do
      event_name = described_class::VIEWED_DESIGN

      expect(described_class.send(:download_event?, event_name)).to be false
    end
  end

  # TODO: remove once https://github.com/rokumatsumoto/boyutluseyler/issues/105 is resolved
  describe '.like_event?' do
    it 'returns true for like event' do
      event_name = described_class::LIKED_DESIGN

      expect(described_class.send(:like_event?, event_name)).to be true
    end

    it 'returns false for other events' do
      event_name = described_class::VIEWED_DESIGN

      expect(described_class.send(:like_event?, event_name)).to be false
    end
  end

  describe '.cached_any_events_for?' do
    let(:user) { create(:user) }
    let(:design) { create(:design) }
    let(:event_name) { described_class::LIKED_DESIGN }
    let(:event_properties) { { design_id: design.id } }

    it 'returns true for an existing event' do
      pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
      create(:ahoy_event, :liked_design, user: user, properties: event_properties)

      result = described_class.cached_any_events_for?(event_name, user, event_properties)

      expect(result).to be true
    end

    it 'returns false when an event does not exist' do
      pending('https://github.com/rokumatsumoto/boyutluseyler/issues/105')
      create(:ahoy_event, :downloaded_design, user: user, properties: event_properties)

      result = described_class.cached_any_events_for?(event_name, user, event_properties)

      expect(result).to be false
    end
  end
end
