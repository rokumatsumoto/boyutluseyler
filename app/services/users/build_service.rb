# frozen_string_literal: true

module Users
  class BuildService < BaseService
    def initialize(current_user, params = {})
      @current_user = current_user
      @params = params.dup
    end

    def execute(skip_authorization: false)
      raise Boyutluseyler::Access::AccessDeniedError unless skip_authorization || can_create_user?

      user_params = build_user_params(skip_authorization: skip_authorization)
      user = User.new(user_params)

      user
    end

    private

    def can_create_user?
      current_user.nil? || current_user.has_role? :admin
    end

    def signup_params
      %i[
        username
        email
        password
        avatar_url
        avatar_thumb_url
      ]
    end

    def build_user_params(skip_authorization:)
      allowed_signup_params = signup_params
      allowed_signup_params << :skip_confirmation if skip_authorization

      user_params = params.slice(*allowed_signup_params)
      if user_params[:skip_confirmation].nil?
        user_params[:skip_confirmation] = skip_user_confirmation_email_from_setting
      end

      user_params
    end

    def skip_user_confirmation_email_from_setting
      false # TODO: add into application settings
    end
  end
end
