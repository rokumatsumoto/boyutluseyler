require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Boyutluseyler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # There is no need to add `lib` to autoload_paths since autoloading is
    # configured to check for eager loaded paths:
    # https://github.com/rails/rails/blob/v4.2.6/railties/lib/rails/engine.rb#L687
    # http://blog.arkency.com/2014/11/dont-forget-about-eager-load-when-extending-autoload
    config.eager_load_paths.push("#{config.root}/lib")

    # Rake tasks ignore the eager loading settings, so we need to set the
    # autoload paths explicitly
    config.autoload_paths = config.eager_load_paths.dup

    config.time_zone = 'Istanbul' # Default time zone

    # auto-load nested translation folders ie: locales/models/foo.yml
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml').to_s]
    config.i18n.default_locale = :tr

    # Disable animations, only for test environments
    config.disable_animations = false

    # TODO: Update CORS for production
    # Enable CORS
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*'
    #     resource '*', headers: :any, methods: [:get, :post, :options]
    #   end
    # end

    # https://guides.rubyonrails.org/configuring.html#initialization-events
    config.before_initialize do
      # We need to wait for the Boyutluseyler.credentials method below
      config.x = config_for(:boyutluseyler).with_indifferent_access
    end
  end

  def self.credentials
    @credentials ||= Rails.application.credentials[Rails.env.to_sym]
  end

  def self.config
    @config ||= Rails.configuration.x
  end
end
