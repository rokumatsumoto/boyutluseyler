# frozen_string_literal: true

module NavHelper
  def header_links
    @header_links ||= fetch_header_links
  end

  def header_link?(link)
    header_links.include?(link)
  end

  private

  def fetch_header_links
    links = if user_signed_in?
              %i[user_dropdown upload]
            else
              [:sign_in]
            end

    links += %i[search designs collections]
    links
  end
end
