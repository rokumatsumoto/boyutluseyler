# frozen_string_literal: true

module Designs
  module PageViews
    class PopularityScoreService
      attr_reader :design

      def initialize(design)
        @design = design
      end

      def execute
        design.update_column(:popularity_score, calculate)
      end

      private

      # (a * t) + ((1 - a) * p)

      # a — coefficient between 0 and 1 (higher values discount older events faster)
      # t — current timestamp
      # p — current popularity value (e.g. stored in a database)

      # Reasonable values for a will depend on your application. A good starting place is
      # a=2/(N+1), where N is the number of events that should significantly affect the
      # outcome. For example, on a low-traffic website where the event is a page view, you
      # might expect hundreds of page views over a period of a few days.
      # Choosing N=100 (a≈0.02) would be a reasonable choice. For a high-traffic website,
      # you might expect millions of page views over a period of a few days, in which case
      # N=1000000 (a≈0.000002) would be more reasonable. The value for a will likely need
      # to be gradually adjusted over time.

      def calculate
        (effect * current_timestamp) + ((1 - effect) * popularity_score)
      end

      def effect
        Design::POPULARITY_EFFECT
      end

      def current_timestamp
        Time.current.to_i
      end

      def popularity_score
        design.popularity_score.zero? ? current_timestamp : design.popularity_score
      end
    end
  end
end
