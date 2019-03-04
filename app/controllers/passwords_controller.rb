# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  before_action :resource_from_email, only: [:create]
  before_action :throttle_reset, only: [:create]
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

    return if reset_password_token.nil?

    user = User.where(
      reset_password_token: reset_password_token
    ).first_or_initialize

    return if user.reset_password_period_valid?

    flash[:alert] = expired_or_invalid_message_for_reset_password_token(user)
    redirect_to(new_user_password_url(user_email: user['email']))
  end

  # https://github.com/plataformatec/devise/blob/master/app/controllers/
  # devise/passwords_controller.rb
  # PUT /resource/password
  def update
    super do |resource|
      unless resource.errors.empty?
        flash[:alert] = expired_or_invalid_message_for_reset_password_token(resource)
        redirect_to(new_user_password_url(user_email: resource['email'])) && return
      end
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

  protected

  def resource_from_email
    email = resource_params[:email]
    self.resource = resource_class.find_by_email(email)
  end

  def throttle_reset
    return unless resource&.recently_sent_password_reset?

    # Throttle reset attempts, but return a normal message to
    # avoid user enumeration attack.
    redirect_to new_user_session_path,
                notice: t('devise.passwords.send_instructions')
  end

  private

  def expired_or_invalid_message_for_reset_password_token(resource)
    if resource.email?
      expired_message_for_reset_password_token
    else
      invalid_message_for_reset_password_token
    end
  end

  def expired_message_for_reset_password_token
    t('errors.messages.expired', attribute:
      t('activerecord.attributes.user.reset_password_token'))
  end

  def invalid_message_for_reset_password_token
    t('errors.messages.invalid', attribute:
      t('activerecord.attributes.user.reset_password_token'))
  end
end
