require_relative "boot"

require "rails/all"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module InitProject
  class Application < Rails::Application

    config.load_defaults 6.0

    I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    I18n.available_locales = [:en, :vi]

    I18n.default_locale = :en

    config.time_zone = "Asia/Bangkok"
  end
end
