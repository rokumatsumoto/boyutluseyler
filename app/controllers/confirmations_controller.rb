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

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      flash[:alert] = expired_or_invalid_message_for_confirmation_token(resource)
      redirect_to(new_user_confirmation_url(user_email: resource['email']))
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
    t('activerecord.attributes.user.confirmation_token') + ' ' +
      resource.errors.full_messages.to_sentence
  end
end
