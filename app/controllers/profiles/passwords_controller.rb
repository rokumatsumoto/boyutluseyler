# frozen_string_literal: true

class Profiles::PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit; end

  def update
    password_attributes = user_params.select do |key, _value|
      %w[password password_confirmation].include?(key.to_s)
    end

    unless @user.valid_password?(user_params[:current_password])
      redirect_to edit_profile_password_path,
                  alert: t('activerecord.errors.models.user.attributes.current_password.invalid')
      return
    end

    result = Users::UpdateService.new(current_user, password_attributes.merge(user: @user)).execute

    if result[:status] == :success
      flash[:notice] = t('devise.registrations.password_updated_but_not_signed_in')
      redirect_to new_user_session_path
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
