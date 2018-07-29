require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require 'active_support'
require 'active_support/core_ext'
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require_relative "../lib/common.rb"
require_relative "../lib/creation.rb"
require_relative "../lib/deletion.rb"
require_relative "../lib/core/core.rb"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.action_cable.mount_path = '/websocket'
    ActionCable.server.config.logger = Logger.new(nil)
    config.action_cable.allowed_request_origins = [ %r{.*} ]
    config.middleware.use ActionDispatch::Cookies  
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins (ENV["SPACEPAL_FRONTEND"] or 'localhost:8080')
        resource '*', headers: :any, credentials: true, methods: [:get, :post, :delete, :options, :put]
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
