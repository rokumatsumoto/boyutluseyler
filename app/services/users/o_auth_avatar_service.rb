# frozen_string_literal: true

module Users
  class OAuthAvatarService
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def execute
      user.avatar_url = handle_avatar_for_url(user.avatar_url)
      user.avatar_thumb_url = handle_avatar_for_url(user.avatar_thumb_url)

      user
    end

    private

    def handle_avatar_for_url(url)
      file = download(url)

      file_path = rename(file)

      key = upload(file_path)

      public_url_for_key(key)
    end

    def download(url)
      Down.download(url)
    end

    def rename(file)
      extension = MiniMime.lookup_by_content_type(file.content_type).extension

      filename = "#{SecureRandom.uuid}.#{extension}"

      destination_path = "#{Dir.tmpdir}/#{filename}"

      FileUtils.mv file.path, destination_path

      destination_path
    end

    def upload(file_path)
      key = generate_key(file_path)

      AWS_S3_CLIENT.put_object(
        acl: acl,
        body: File.read(file_path),
        bucket: bucket,
        key: key
      )

      key
    end

    def acl
      Boyutluseyler.config[:bucket_acl]
    end

    def bucket
      Boyutluseyler.config[:processed_bucket_name]
    end

    def generate_key(file_path)
      filename = File.basename(file_path)

      "#{key_prefix}/#{filename}"
    end

    def key_prefix
      [
        'uploads',
        'user',
        'avatar-file',
        user_uuid
      ].join('/')
    end

    def user_uuid
      @user_uuid ||= SecureRandom.uuid
    end

    def public_url_for_key(key)
      "#{Boyutluseyler.config[:processed_endpoint]}/#{key}"
    end
  end
end
