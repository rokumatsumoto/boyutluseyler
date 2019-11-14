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

    belongs_to :visit
    belongs_to :user, optional: true

    belongs_to :design, class_name: 'Design', store: :properties, optional: true
    counter_culture :design, column_name: proc { |model|
      model.name == 'Downloaded design' ? 'downloads_count' : nil
    }
  end
end
