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
  # https://github.com/plataformatec/devise/blob/master/app/controllers/
  # devise/unlocks_controller.rb
  # GET /resource/unlock?unlock_token=abcdef
  def show
    super do |resource|
      unless resource.errors.empty?
        flash[:alert] = expired_or_invalid_message_for_unlock_token(resource)
        redirect_to(new_user_unlock_url(user_email: resource['email'])) && return
      end
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
