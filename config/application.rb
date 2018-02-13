require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Beeleev
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Paris'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += ['website.js', 'website.css']

    # Enable HTML assets (mostly for 404.html and 500.html)
    # Don't forget to un-fingerprint and copy compiled 404 and 500 back to /public
    #
    # see
    #   http://devoh.com/blog/2012/09/asset-pipeline-error-pages
    #   http://geekmonkey.org/articles/29-exception-applications-in-rails-3-2
    #
    config.assets.paths << Rails.root.join('app/assets/html')
    config.assets.precompile += %w(*.html)

    config.action_mailer.delivery_method = :smtp

    config.middleware.insert_before ActionDispatch::Static, Rack::Deflater

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r302 '/newsfeed', '/'
    end
    # serve error pages from the Rails app itself > see routes.
    config.exceptions_app = self.routes
  end
end
