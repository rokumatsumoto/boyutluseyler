# frozen_string_literal: true

module UploadsActions
  include Boyutluseyler::Utils::StrongMemoize

  def new
    presigned_post = Files::DirectUpload::CreatePresignedPostService
                     .new(model, uploader_context).execute

    render_presigned_post(presigned_post)
  end

  private

  def render_presigned_post(presigned_post)
    render json: presigned_post.fields, status: :ok
  end

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
