# frozen_string_literal: true

require 'simplecov'

module SimpleCovEnv
  module_function

  def start!
    return unless ENV['SIMPLECOV']

    SimpleCov.start
  end
end
