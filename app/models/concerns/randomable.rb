# frozen_string_literal: true

module Randomable
  extend ActiveSupport::Concern

  class_methods do
    def random(the_count = 1)
      records = offset(rand(count - the_count + 1)).limit(the_count)
      the_count == 1 ? records.first : records
    end
  end
end
