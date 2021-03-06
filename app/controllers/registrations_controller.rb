# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]
  after_action :after_create, only: :create, if: -> { resource.persisted? }

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params)
    else
      super
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_up_params
    flash[:danger] = flash[:recaptcha_error]
    flash.delete :recaptcha_error
    set_minimum_password_length
    respond_with_navigational(resource) { render :new }
  end

  def after_create
    Users::AfterCreateService.new(resource).execute
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password)
  end
end
