# frozen_string_literal: true

module UploadsActions
  def new
    presigned_post = Files::DirectUpload::CreatePresignedPostService
                     .new(policy, direct_upload_context).execute

    render json: presigned_post.fields, status: :ok
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  end

  private

  def direct_upload_context
    {
      current_user_id: current_user.id
    }
  end

  def find_policy
    nil
  end

  def policy
    find_policy
  end

  def upload_params
    params.permit(:policy_name)
  end
end
