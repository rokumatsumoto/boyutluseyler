# frozen_string_literal: true

class UploadsController < ApplicationController
  include UploadsActions

  UnknownUploadPolicyError = Class.new(StandardError)

  POLICY_CLASSES = {
    'blueprint'    => BlueprintDirectUploadPolicy,
    'illustration' => IllustrationDirectUploadPolicy,
    'user_avatar'  => AvatarDirectUploadPolicy
  }.freeze

  rescue_from UnknownUploadPolicyError, with: :render_404

  before_action :authenticate_user!
  before_action :find_policy

  def find_policy
    @find_policy ||= upload_policy_class
  end

  def upload_policy_class
    POLICY_CLASSES[upload_params[:policy_name]] || raise(UnknownUploadPolicyError)
  end
end
