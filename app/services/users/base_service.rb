# frozen_string_literal: true

module Users
  class BaseService < ::BaseService
    protected

    attr_reader :current_user
    attr_accessor :user, :params

    def initialize(user, current_user = nil, params = {})
      @user = user
      @current_user = current_user
      @params = params.dup
    end
  end
end
