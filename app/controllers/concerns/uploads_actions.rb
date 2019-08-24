# frozen_string_literal: true

module UploadsActions
  include Boyutluseyler::Utils::StrongMemoize

  def new
    presigned_post = Files::DirectUpload::CreatePresignedPostService
                     .new(model, uploader_context).execute

    render json: presigned_post.fields, status: :ok
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  end

  private

  def uploader_context
    {
      current_user_id: current_user.id
    }
  end

  def find_model
    nil
  end

  def model
    find_model
  end

  def upload_params
    params.permit(:model)
  end
end
