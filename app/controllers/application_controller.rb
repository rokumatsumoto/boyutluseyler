# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Boyutluseyler::GonHelper
  include Pagy::Backend
  include Pundit

  protect_from_forgery with: :exception, prepend: true
  # protect_from_forgery with: :null_session # for postman

  before_action :add_gon_variables, unless: [:json_request?]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate
  # the user as `authenticate_user!` (or whatever your resource is) will halt the filter
  # chain and redirect before the location can be stored.
  after_action :verify_authorized, unless: :devise_controller?

  protected

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActionController::ParameterMissing do |e|
    render json: e.message, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    # TODO: log exception
    render_404
  end

  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  def json_request?
    request.format.json?
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def redirect_back_or_default(default: root_path, options: {})
    redirect_back(fallback_location: default, **options)
  end

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('public/404'), layout: false, status: 404 }
      # Prevent the Rails CSRF protector from thinking a missing .js file is a JavaScript file
      format.js { render json: '', status: :not_found, content_type: 'application/json' }
      format.any { head :not_found }
    end
  end

  def render_403
    respond_to do |format|
      format.html { render file: Rails.root.join('public/403'), layout: false, status: 403 }
      format.any { head :forbidden }
    end
  end

  # https://github.com/plataformatec/devise#strong-parameters
  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: %i[username email
                                                         password login
                                                         remember_me]
    devise_parameter_sanitizer.permit :account_update,
                                      keys: added_attrs << :current_password
  end

  private

  def user_not_authorized(e)
    message = e.reason || :default
    flash[:alert] = I18n.t("errors.#{message}", scope: 'pundit', default: :default)
    redirect_to(request.referer || root_path)
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as
  # that could cause an infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice:
    helpers.pagy_t('pagy.error.overflow', page: params[:page], last_page: exception.pagy.last)
  end
end
