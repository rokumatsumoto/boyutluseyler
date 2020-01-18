# frozen_string_literal: true

# Define allowed roles that can be used
# in Boyutluseyler code to determine authorization level
#
module Boyutluseyler
  module Access
    AccessDeniedError = Class.new(StandardError)
  end
end
