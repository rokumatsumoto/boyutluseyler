# frozen_string_literal: true

module NavHelper
  def header_links
    @header_links ||= collect_header_links
  end

  def header_link?(link)
    header_links.include?(link)
  end

  private

  def collect_header_links
    links = if current_user
              %i[user_dropdown]
            else
              [:sign_in]
            end

    links += %i[search upload designs collections]
    links
  end
end
