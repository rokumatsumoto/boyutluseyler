# frozen_string_literal: true

module Boyutluseyler
  class FunctionCaller
    attr_accessor :function_name, :payload

    # If you specify only the function name, it is limited to 64 characters in length.
    def initialize(function_name, payload)
      @function_name = function_name
      @payload = payload
    end

    def call
      return unless defined?(AWS_LAMBDA)

      response = AWS_LAMBDA.invoke(function_name: function_name, payload: payload)
      JSON.parse(JSON.parse(response.payload.as_json[0])['body'])['message']
    end
  end
end
