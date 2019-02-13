# frozen_string_literal: true

class UsersController < ApplicationController
  def username_validator
    return if current_user_username?

    if User.find_by('lower(username) = :username', username: params[:username].downcase)
      # TODO: return valid with message and set correspond translation(i18n)
      render json: { valid: false }
    else
      render json: { valid: true }
    end
  end

  private

  # OPTIMIZE: access session info from js
  def current_user_username?
    if user_signed_in? &&
       current_user.username == params[:username]
      # TODO: return valid with message and set correspond translation(i18n)
      render json: { valid: true }
    end
  end
end
