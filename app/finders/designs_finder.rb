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
    collection = with_illustrations(collection)
    collection = by_popularity(collection)

    collection
  end

  def with_illustrations(items)
    params[:with_illustrations].present? ? items.with_illustrations : items
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
