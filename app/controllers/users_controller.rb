# frozen_string_literal: true

class UsersController < ApplicationController
  def exists
    if User.exists?(['lower(username) = :username', username: params[:username].downcase(:turkic)])
      render json: { exists: true }
    else
      render json: { exists: false }
    end
  rescue StandardError
    render json: { message: t('activerecord.errors.models.user.attributes.username.error') },
           status: 500
  end
end
