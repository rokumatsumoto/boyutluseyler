# frozen_string_literal: true

class UsersController < ApplicationController
  def exists
    if User.find_by('lower(username) = :username', username: params[:username].downcase)
      message = t('activerecord.errors.models.user.attributes.username.taken')
      render json: { exists: true, message: message }
    else
      render json: { exists: false }
    end
  end
end
