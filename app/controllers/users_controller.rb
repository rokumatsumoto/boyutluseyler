# frozen_string_literal: true

class UsersController < ApplicationController
  def exists
    if User.exists?(['lower(username) = :username', username: params[:username].downcase])
      render json: { exists: true, message: taken_message_for_username }
    else
      render json: { exists: false }
    end
  end

  private

  def taken_message_for_username
    t('activerecord.errors.models.user.attributes.username.taken')
  end
end
