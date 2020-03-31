# frozen_string_literal: true

module DatabaseHelpers
  private

  def database_client
    @database_client ||= Database.client
  end
end
