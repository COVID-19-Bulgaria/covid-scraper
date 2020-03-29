# frozen_string_literal: true

require 'rack'
require 'delegate'
require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

require_relative './crontab'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

run Sidekiq::Web
