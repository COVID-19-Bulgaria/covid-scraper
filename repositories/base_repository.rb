# frozen_string_literal: true

class BaseRepository
  def initialize(database_client)
    @database_client = database_client
  end

  private

  attr_reader :database_client
end
