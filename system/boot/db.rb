# frozen_string_literal: true

CovidScraper::Application.boot(:db) do
  init do
    require 'rom'
    require 'rom-sql'
    require 'rom/transformer'

    register('db.config', ROM::Configuration.new(
      :sql, ENV['DATABASE_URL'],
      extensions: [
        :connection_validator
      ]
    ))
  end
end
