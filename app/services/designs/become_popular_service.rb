# frozen_string_literal: true

module Designs
  class BecomePopularService
    def execute
      design_list = Design.most_popular

      design_list.reverse.each do |design|
        design.update_column(:home_popular_at, Time.current)
      end
    end
  end
end
