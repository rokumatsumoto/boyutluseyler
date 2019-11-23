# frozen_string_literal: true

class PagesController < ApplicationController
  include CategoriesHelper
  def home
    @random_categories = fetch_random_categories
  end
end
