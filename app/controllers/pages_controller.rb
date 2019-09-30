# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @random_categories = Category.random(4) unless user_signed_in?
  end

  # TODO: remove
  def test_stl_viewer; end
end
