# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
    reset_password_token = Devise.token_generator.digest(
      User,
      :reset_password_token,
      resource.reset_password_token
    )

    unless reset_password_token.nil?
      user = User.where(
        reset_password_token: reset_password_token
      ).first_or_initialize

      unless user.reset_password_period_valid?
        flash[:alert] = expired_or_invalid_message_for_reset_password_token(user)
        redirect_to(new_user_password_url(user_email: user['email']))
      end
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      flash[:alert] = expired_or_invalid_message_for_reset_password_token(resource)
      redirect_to(new_user_password_url(user_email: resource['email']))
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def expired_or_invalid_message_for_reset_password_token(resource)
    if resource.email?
      expired_or_invalid = resource.errors.full_messages.to_sentence
      expired_or_invalid = t('errors.messages.expired') if resource.errors.messages.empty?

      reset_password_token_translation + ' ' + expired_or_invalid
    else
      reset_password_token_translation + ' ' +
        t('errors.messages.invalid')
    end
  end

  def reset_password_token_translation
    t('activerecord.attributes.user.reset_password_token')
  end
end
