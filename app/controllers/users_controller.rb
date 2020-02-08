# frozen_string_literal: true

class UsersController < ApplicationController
  def exists
    skip_authorization

    if User.find_by_username(params[:username]) # rubocop:disable Rails/DynamicFindBy
      render json: { exists: true }
    else
      render json: { exists: false }
    end
  rescue StandardError
    render json: { message: t('activerecord.errors.models.user.attributes.username.error') },
           status: 500
  end
end
