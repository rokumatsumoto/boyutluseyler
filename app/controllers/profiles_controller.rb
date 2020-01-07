# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :user

  def show; end

  def update
    respond_to do |format|
      result = Users::UpdateService.new(current_user, user_params.merge(user: @user)).execute

      if result[:status] == :success
        message = t('devise.registrations.updated')

        format.html { redirect_back_or_default(default: { action: 'show' }, options: { notice: message }) }
        format.json { render json: { message: message } }
      else
        format.html { redirect_back_or_default(default: { action: 'show' }, options: { alert: result[:message] }) }
        format.json { render json: result }
      end
    end
  end

  private

  def user
    @user = current_user
  end

  def user_params
    @user_params ||= params.require(:user).permit(
      :email,
      :username,
      :avatar_url
    )
  end
end
