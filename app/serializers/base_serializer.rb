# frozen_string_literal: true

class BaseSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
end
