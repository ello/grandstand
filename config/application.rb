# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require "active_job/railtie"
require 'active_record/railtie'
require 'action_controller/railtie'
# require "action_mailer/railtie"
require 'action_view/railtie'
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Grandstand
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.paths.add 'app/interactors', eager_load: true

    # Use SQL-formatted schema dumps for Partman
    config.active_record.schema_format = :sql

    # Use basic auth if it's configured
    if ENV['BASIC_AUTH_USER'] && ENV['BASIC_AUTH_PASSWORD']
      config.middleware.use ::Rack::Auth::Basic do |u, p|
        [u, p] == [ENV['BASIC_AUTH_USER'], ENV['BASIC_AUTH_PASSWORD']]
      end
    end
  end
end
