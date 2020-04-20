# frozen_string_literal: true

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

module Ahoy
  class Event < ApplicationRecord
    include Ahoy::QueryMethods

    self.table_name = 'ahoy_events'

    VIEWED_DESIGN = 'Viewed design'
    LIKED_DESIGN = 'Liked design'
    DOWNLOADED_DESIGN = 'Downloaded design'

    USER_EVENTS = [LIKED_DESIGN, DOWNLOADED_DESIGN].freeze

    belongs_to :visit
    belongs_to :user, optional: true
    counter_culture :user,
                    column_name: proc { |e| user_event?(e.name) ? 'events_count' : nil },
                    touch: 'updated_at'

    belongs_to :design, class_name: 'Design', store: :properties, optional: true
    counter_culture :design,
                    column_name: proc { |e| download_event?(e.name) ? 'downloads_count' : nil }
    counter_culture :design,
                    column_name: proc { |e| like_event?(e.name) ? 'likes_count' : nil }

    class << self
      def user_event?(event_name)
        USER_EVENTS.include? event_name
      end

      def download_event?(event_name)
        event_name == DOWNLOADED_DESIGN
      end

      def like_event?(event_name)
        event_name == LIKED_DESIGN
      end

      def cached_any_events_for?(event_name, user, event_properties)
        _event_fk, event_id = event_properties.first # key, value = hash.first

        cache_name = "any_events_for-#{event_name.parameterize.underscore}-#{event_id}-#{user.updated_at}"
        Rails.cache.fetch(cache_name, expires_in: 1.week) do
          Ahoy::Event.where(name: event_name, properties: event_properties, user_id: user.id).any?
        end
      end
    end
  end
end
