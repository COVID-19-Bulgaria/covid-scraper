# frozen_string_literal: true

require 'pg'

module Database
  class << self
    def client
      PG.connect(
        host: ENV['POSTGRES_HOST'],
        port: ENV['POSTGRES_PORT'],
        dbname: ENV['POSTGRES_DB'],
        user: ENV['POSTGRES_USER'],
        password: ENV['POSTGRES_PASSWORD']
      )
    end
  end
end
