# frozen_string_literal: true

module NavHelper
  def navbar_class(use_hero)
    return 'navbar-transparent navbar-light' if use_hero

    'navbar-dark bg-default navbar-colored'
  end

  def header_links
    @header_links ||= collect_header_links
  end

  def header_link?(link)
    header_links.include?(link)
  end

  def add_header_links(anonymous_header_links, logged_in_header_links)
    self.anonymous_links = anonymous_header_links
    self.logged_in_links = logged_in_header_links
  end

  private

  def collect_header_links
    links = if current_user
              logged_in_links
            else
              anonymous_links
            end
    links
  end

  def anonymous_links=(anonymous_header_links)
    anonymous_links
    @anonymous_links += anonymous_header_links
  end

  def logged_in_links=(logged_in_header_links)
    logged_in_links
    @logged_in_links += logged_in_header_links
  end

  def anonymous_links
    @anonymous_links ||= []
  end

  def logged_in_links
    @logged_in_links ||= %i[user_dropdown]
  end
end
