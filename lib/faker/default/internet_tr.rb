# frozen_string_literal: true

module Faker
  module Default
    class InternetTr < Faker::Internet
      def self.username(specifier)
        changes = {
          'İ' => 'I'
        }

        changes.each do |old, new|
          specifier[:specifier] = specifier[:specifier].gsub(old, new)
        end

        super(specifier)
      end
    end
  end
end
