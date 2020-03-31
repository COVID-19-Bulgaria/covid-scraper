# frozen_string_literal: true

require_relative './base_repository'

class PlacesRepository < BaseRepository
  def latest
    database_client.exec('select * from covid19.latest_places_cases')
  end
end
