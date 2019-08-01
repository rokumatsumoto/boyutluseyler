class IllustrationSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :id, :url, :size, :image_url
  attribute :filename do |object|
    File.basename(object.url_path)
  end
end
