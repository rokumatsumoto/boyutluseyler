# frozen_string_literal: true

class UnlocksController < Devise::UnlocksController
  # GET /resource/unlock/new
  # def new
  #   super
  # end

  # POST /resource/unlock
  # def create
  #   super
  # end

  # GET /resource/unlock?unlock_token=abcdef
  def show
    self.resource = resource_class.unlock_access_by_token(params[:unlock_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message! :notice, :unlocked
      respond_with_navigational(resource){ redirect_to after_unlock_path_for(resource) }
    else
      flash[:alert] = expired_or_invalid_message_for_unlock_token(resource)
      redirect_to(new_user_unlock_url(user_email: resource['email']))
    end
  end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  # The path used after unlocking the resource
  # def after_unlock_path_for(resource)
  #   super(resource)
  # end

  private

  def expired_or_invalid_message_for_unlock_token(resource)
    t('activerecord.attributes.user.unlock_token') + ' ' +
      resource.errors.full_messages.to_sentence
  end
end
