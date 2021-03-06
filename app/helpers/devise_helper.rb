# frozen_string_literal: true

module DeviseHelper
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def confirmation_page_email_value
    return params[:user_email] unless params[:user_email].blank?

    (resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email)
  end
end
