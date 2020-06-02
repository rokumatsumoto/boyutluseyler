require 'simplecov'

module SimpleCovEnv
  extend self

  def start!
    return unless ENV['SIMPLECOV']

    SimpleCov.start 'rails'
  end
end
