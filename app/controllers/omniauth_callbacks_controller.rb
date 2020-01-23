# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  include AuthHelper

  def handle_omniauth
    omniauth_flow(Boyutluseyler::Auth::OAuth)
  end

  AuthHelper.auth_providers.each do |provider|
    alias_method provider, :handle_omniauth
  end

  def omniauth_error
    @provider = params[:provider]
    @error = params[:error]
    render 'errors/omniauth_error', layout: 'oauth_error', status: 422
  end

  private

  def omniauth_flow(auth_module, identity_linker: nil)
    if current_user
      return unless link_provider_allowed?(oauth['provider'])

      identity_linker ||= auth_module::IdentityLinker.new(current_user, oauth)

      link_identity(identity_linker)

      if identity_linker.changed?
        redirect_identity_linked
      elsif identity_linker.failed?
        redirect_identity_link_failed(identity_linker.error_message)
      else
        redirect_identity_exists
      end
    else
      sign_in_user_flow(auth_module::User)
    end
  end

  def link_identity(identity_linker)
    identity_linker.link
  end

  def redirect_identity_exists
    redirect_to after_sign_in_path_for(current_user)
  end

  def redirect_identity_linked
    redirect_to profile_account_path, notice: t('oauth.updated')
  end

  def redirect_identity_link_failed(error_message)
    redirect_to profile_account_path, notice: t('oauth.failed', error_message: error_message)
  end

  def build_auth_user(auth_user_class)
    auth_user_class.new(oauth)
  end

  def sign_in_user_flow(auth_user_class)
    auth_user = build_auth_user(auth_user_class)
    user = auth_user.find_and_update!

    if auth_user.valid_sign_in?
      set_remember_me(user)

      sign_in_and_redirect(user)
    else
      fail_login(user)
    end
  end

  def oauth
    @oauth ||= request.env['omniauth.auth']
  end

  def fail_login(user)
    error_message = user.errors.full_messages.to_sentence

    redirect_to omniauth_error_path(oauth['provider'], error: error_message)
  end

  def set_remember_me(user)
    return unless remember_me?

    remember_me(user)
  end

  def remember_me?
    request_params = request.env['omniauth.params']
    (request_params['remember_me'] == '1') if request_params.present?
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
