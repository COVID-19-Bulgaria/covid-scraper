# frozen_string_literal: true

require_relative './crontab'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

run Sidekiq::Web
