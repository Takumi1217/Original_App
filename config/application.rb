require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 7.0

    # デフォルトの言語を日本語に設定
    config.i18n.default_locale = :ja
    # 利用可能な言語を日本語と英語に設定
    config.i18n.available_locales = [:ja, :en]
  end
end
