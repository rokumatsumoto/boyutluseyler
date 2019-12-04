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

    collection
  end

  def with_illustrations(items)
    params[:with_illustrations].present? ? items.with_illustrations : items
  end

  def sort(items)
    return items unless sort?

    items.sort_by_attribute(params[:sort])
  end

  def sort?
    params[:sort].present?
  end
end
