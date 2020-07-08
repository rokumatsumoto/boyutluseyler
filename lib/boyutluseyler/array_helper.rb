# frozen_string_literal: true

module Boyutluseyler
  module ArrayHelper
    def array_changed?(existing_array, new_array)
      return false if array_empty?(new_array)

      return false if array_equal?(existing_array, new_array)

      true
    end

    def array_match?(my_array, other_array)
      return true if my_array.sort == other_array.sort
    end

    def array_equal?(my_array, other_array)
      return true if my_array == other_array
    end

    def array_empty?(my_array)
      my_array.all?(&:blank?)
    end
  end
end
