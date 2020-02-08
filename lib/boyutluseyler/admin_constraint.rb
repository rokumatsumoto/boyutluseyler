# frozen_string_literal: true

module Boyutluseyler
  class AdminConstraint
    def self.matches?(request)
      user = request.env['warden'].user(:user)
      user && user.roles.where(name: 'admin').count > 0
    end
  end
end
