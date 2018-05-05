require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cogli
  class Application < Rails::Application
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  # config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  # config.i18n.default_locale = :de

    config.autoload_paths << Rails.root.join('lib')

    config.active_record.raise_in_transactional_callbacks = true

    config.assets.paths << "#{Rails.root}/app/assets/files"

    config.to_prepare do
      DeviseController.respond_to :html, :json
      DeviseController.layout "application"
      DeviseController.protect_from_forgery with: :null_session, if: -> { request.format.json? }

      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/decorators/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Monkey Patch
      # Gcloud File Storage
      c = File.join(
        File.dirname(__FILE__),
        '../lib/extensions/carrierwave-google-storage/gcloud_file.rb'
      )
      Rails.configuration.cache_classes ? require(c) : load(c)
    end

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
