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
end
