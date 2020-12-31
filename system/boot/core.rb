# frozen_string_literal: true

CovidScraper::Application.boot(:core) do
  init do
    require 'dry-types'
    require 'dry-validation'
    require 'dry/monads'
    require 'dry/monads/do'
    require 'nokogiri'
    require 'open-uri'
    require 'json'
    require 'pragmatic_segmenter'
    require 'pragmatic_tokenizer'
    require 'fuzzy_match'
    require 'git'
    require 'rack'
    require 'delegate'
    require 'sidekiq'
    require 'sidekiq/web'
    require 'sidekiq-cron'
    require 'sidekiq/cron/web'

    module Types
      include Dry.Types()
    end
  end

  start do
    Dry::Validation.load_extensions(:monads)
  end
end
