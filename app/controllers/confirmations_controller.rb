# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # https://github.com/plataformatec/devise/blob/master/app/controllers/
  # devise/confirmations_controller.rb
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |resource|
      unless resource.errors.empty?
        flash[:alert] = expired_or_invalid_message_for_confirmation_token(resource)
        redirect_to(new_user_confirmation_url(user_email: resource['email'])) && return
      end
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  protected

  def after_confirmation_path_for(resource_name, resource)
    flash[:success] = flash[:notice]
    flash.delete :notice
    super(resource_name, resource)
  end

  private

  def expired_or_invalid_message_for_confirmation_token(resource)
    if resource.email?
      expired_message_for_confirmation_token
    else
      invalid_message_for_confirmation_token
    end
  end

  def expired_message_for_confirmation_token
    t('activerecord.attributes.user.confirmation_token') +
      resource.errors.full_messages.to_sentence
    # -> errors.messages.confirmation_period_expired
  end

  def invalid_message_for_confirmation_token
    t('errors.messages.invalid', attribute:
      t('activerecord.attributes.user.confirmation_token'))
  end
end
