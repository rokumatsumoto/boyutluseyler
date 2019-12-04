# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  included do
    scope :with_order_id_desc, -> { order(id: :desc) }
    scope :order_id_desc, -> { reorder(id: :desc) }
    scope :order_id_asc, -> { reorder(id: :asc) }
    scope :order_created_desc, -> { reorder(created_at: :desc) }
    scope :order_created_asc, -> { reorder(created_at: :asc) }
    scope :order_updated_desc, -> { reorder(updated_at: :desc) }
    scope :order_updated_asc, -> { reorder(updated_at: :asc) }
    scope :order_name_asc, -> { reorder(Arel::Nodes::Ascending.new(arel_table[:name].lower)) }
    scope :order_name_desc, -> { reorder(Arel::Nodes::Descending.new(arel_table[:name].lower)) }
  end

  class_methods do
    def order_by(method)
      simple_sorts.fetch(method.to_s, -> { all }).call
    end

    def simple_sorts
      {
        'created_asc' => -> { order_created_asc },
        'created_date' => -> { order_created_desc },
        'created_desc' => -> { order_created_desc },
        'id_asc' => -> { order_id_asc },
        'id_desc' => -> { order_id_desc },
        'name_asc' => -> { order_name_asc },
        'name_desc' => -> { order_name_desc },
        'updated_asc' => -> { order_updated_asc },
        'updated_desc' => -> { order_updated_desc }
      }
    end
  end
end
