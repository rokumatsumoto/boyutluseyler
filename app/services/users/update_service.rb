# frozen_string_literal: true

module Users
  class UpdateService < BaseService
    def initialize(current_user, params = {})
      @current_user = current_user
      @user = params.delete(:user)
      @params = params.dup
    end

    def execute(validate: true, &block) # rubocop:disable Lint/UnusedMethodArgument
      yield(@user) if block_given?

      assign_attributes

      if @user.save(validate: validate)
        success
      else
        messages = @user.errors.full_messages
        error(messages.uniq.join('. '))
      end
    end

    private

    def assign_attributes
      @user.assign_attributes(params) unless params.empty?
    end
  end
end
