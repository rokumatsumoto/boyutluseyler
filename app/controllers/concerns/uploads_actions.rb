# frozen_string_literal: true

module UploadsActions
  include Boyutluseyler::Utils::StrongMemoize

  def new
    presigned_post = DirectUploadService.new(model, direct_upload_provider,
                                             uploader_context).execute

    render_presigned_post(presigned_post)
  end

  def render_presigned_post(presigned_post)
    case direct_upload_provider
    when Providers::AWS.name.demodulize
      render json: presigned_post.fields, status: :ok
    end
  end

  def direct_upload_provider
    # AWS, Google
    Boyutluseyler.config[:direct_upload_provider]
  end

  def uploader_context
    {
      current_user_id: current_user.id
    }
  end

  private

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
