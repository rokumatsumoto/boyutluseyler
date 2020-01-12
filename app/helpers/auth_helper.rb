# frozen_string_literal: true

module AuthHelper
  extend self
  PROVIDERS_WITH_ICONS = %w[twitter google_oauth2 facebook].freeze

  def auth_providers
    Boyutluseyler::Auth::OAuth::Provider.providers
  end

  def provider_has_icon?(name)
    PROVIDERS_WITH_ICONS.include?(name.to_s)
  end

  def label_for_provider(name)
    Boyutluseyler::Auth::OAuth::Provider.label_for(name)
  end

  def provider_image_tag(provider, size = 64)
    label = label_for_provider(provider)

    if provider_has_icon?(provider)
      file_name = "#{provider.to_s.split('_').first}_#{size}.png"

      # TODO: i18n
      image_tag("auth_buttons/#{file_name}", alt: label, title: "#{label} ile bağlan")
    else
      label
    end
  end
end
