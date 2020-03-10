# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    skip_authorization

    # TODO: refactor action

    @most_downloaded = Design.cached_most_downloaded

    @popular_designs = Design.cached_popular_designs
  end
end
