# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'
require 'rack/protection'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KontesTerbuka
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are
    # automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of
    # tasks for finding time zone names. Default is UTC.

    # The default locale is :en and all translations
    # from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join(
    # 'my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.use Rack::Protection
    config.autoload_paths.push("#{config.root}/lib")
    config.active_job.queue_adapter = :delayed_job
    config.active_record.schema_format = :sql
  end

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
