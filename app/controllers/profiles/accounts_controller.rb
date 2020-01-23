# frozen_string_literal: true

class Profiles::AccountsController < ApplicationController
  include AuthHelper

  before_action :authenticate_user!
  before_action :set_user, except: %i[unlink]

  def show; end

  def unlink
    provider = params[:provider]
    identity = current_user.identities.find_by(provider: provider)

    return render_404 unless identity

    identity.destroy if unlink_provider_allowed?(provider)

    redirect_to profile_account_path
  end

  private

  def set_user
    @user = current_user
    authorize @user
  end
end
