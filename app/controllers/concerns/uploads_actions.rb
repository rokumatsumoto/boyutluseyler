# frozen_string_literal: true

module UploadsActions
  def new
    authorize :direct_upload, :new?

    presigned_post = Files::DirectUpload::CreatePresignedPostService
                     .new(direct_upload_policy, direct_upload_context).execute

    render json: presigned_post.fields, status: :ok
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  rescue Pundit::NotAuthorizedError
    render json: t('pundit.errors.design.direct_upload'), status: :forbidden
  end

  private

  def direct_upload_context
    {
      current_user_id: current_user.id
    }
  end

  def find_upload_policy
    nil
  end

  def direct_upload_policy
    @direct_upload_policy ||= find_upload_policy
  end

  def upload_params
    params.permit(:policy_name)
  end
end
