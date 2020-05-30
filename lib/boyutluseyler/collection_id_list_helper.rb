# frozen_string_literal: true

module Boyutluseyler
  module CollectionIdListHelper
    def collection_ids_changed?(existing_ids, new_ids)
      return false if collection_ids_empty?(new_ids)

      return false if collection_ids_equal?(existing_ids, new_ids)

      true
    end

    def collection_ids_match?(collection_ids, other_collection_ids)
      return true if collection_ids.sort == other_collection_ids.sort
    end

    def collection_ids_equal?(collection_ids, other_collection_ids)
      return true if collection_ids == other_collection_ids
    end

    def collection_ids_empty?(collection_ids)
      collection_ids.all?(&:blank?)
    end
  end
end
