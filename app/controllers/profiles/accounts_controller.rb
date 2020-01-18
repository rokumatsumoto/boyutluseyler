# frozen_string_literal: true

class Profiles::AccountsController < ApplicationController
  def show; end

  def unlink
    provider = params[:provider]
    identity = current_user.identities.find_by(provider: provider)

    return render_404 unless identity

    identity.destroy

    redirect_to profile_account_path
  end
end
