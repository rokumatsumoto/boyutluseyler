# frozen_string_literal: true

class DesignsFinder
  def initialize(params = {})
    @params = params
  end

  def execute
    collection = Design.all

    collection = filter_designs(collection)

    sort(collection)
  end

  private

  attr_reader :params

  def filter_designs(collection)
    collection = with_illustration(collection)
    collection = by_popularity(collection)

    collection
  end

  def with_illustration(items)
    params[:with_illustration].present? ? items.with_illustration : items
  end

  def by_popularity(items)
    params[:popularity].present? ? items.popular : items
  end

  def sort(items)
    return items unless sort?

    items.sort_by_attribute(direction? ? sort_with_direction : params[:sort])
  end

  def sort?
    params[:sort].present?
  end

  def direction?
    params[:direction].present?
  end

  def sort_with_direction
    "#{params[:sort]}_#{params[:direction]}"
  end
end
