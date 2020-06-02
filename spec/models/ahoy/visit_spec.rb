# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint(8)        not null, primary key
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint(8)
#  ip               :string
#  user_agent       :text
#  referrer         :text
#  referring_domain :string
#  landing_page     :text
#  browser          :string
#  os               :string
#  device_type      :string
#  utm_source       :string
#  utm_medium       :string
#  utm_term         :string
#  utm_content      :string
#  utm_campaign     :string
#  app_version      :string
#  os_version       :string
#  platform         :string
#  started_at       :datetime
#

require 'spec_helper'

RSpec.describe Ahoy::Visit, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:events).class_name('Ahoy::Event') }
    it { is_expected.to belong_to(:user).optional }
  end
end
