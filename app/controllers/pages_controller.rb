# frozen_string_literal: true

class PagesController < ApplicationController
  include CategoriesHelper
  include DesignsHelper

  def home
    @random_categories = fetch_random_categories

    @most_downloaded = fetch_most_downloaded
  end
end
