# frozen_string_literal: true

class BuildSerializer < BaseSerializer
  attr_reader :args

  def initialize(*args)
    @args = args
  end

  def serialize
    options = args.extract_options!
    collection = args.first
    collection = paginate_collection(collection) if options[:paginate] == true
    serializer_key = options[:serializer] || compute_collection_type(collection)
    serializer_class_name = compute_serializer_name(serializer_key)
    serializer_options = build_fast_jsonapi_options(options)

    serializer_class_name.new(collection, serializer_options).serialized_json
  end

  private

  def compute_serializer_name(serializer_key)
    return serializer_key unless serializer_key.is_a? Symbol

    (serializer_key.to_s.classify + 'Serializer').constantize
  end

  def compute_collection_type(collection)
    if collection.is_a?(ActiveRecord::Relation)
      # ActiveRecord::Relation has a #klass method to divulge the class of records it contains
      collection_class = collection.klass
    else
      collection_class = collection.class
    end

    collection_class.base_class.name.to_sym
  end

  def paginate_collection(collection)
    # Implement pagination
  end

  def build_fast_jsonapi_options(options)
    json_options = {
      params: options[:params] || {},
      meta: options[:meta] || {},
      fields: options[:fields] || {}
    }

    includes = options[:include]
    json_options[:include] = includes_array(includes) if includes.present?

    json_options
  end

  def includes_array(includes)
    includes.is_a?(Array) ? includes : [includes]
  end
end
