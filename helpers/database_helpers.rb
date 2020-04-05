# frozen_string_literal: true

require_relative '../db/database'

module DatabaseHelpers
  private

  def database_client
    @database_client ||= Database.client
  end
end
