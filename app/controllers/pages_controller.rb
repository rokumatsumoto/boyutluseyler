# frozen_string_literal: true

class PagesController < ApplicationController
  include CategoriesHelper
  include DesignsHelper

  def home
    skip_authorization

    # TODO: refactor action

    @most_downloaded = fetch_most_downloaded

    @popular_designs = fetch_popular_designs
  end
end
