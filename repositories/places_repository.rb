# frozen_string_literal: true

require_relative './base_repository'

class PlacesRepository < BaseRepository
  def initialize(database_client)
    super
    prepare_find_latest_places_cases_by_country_id_statement
    prepare_insert_places_cases_statement
  end

  def find_by_country_id(country_id)
    database_client.exec_prepared(
      'find_latest_places_cases_by_country_id',
      [country_id]
    )
  end

  def insert(places_cases)
    return if places_cases.empty?

    places_cases.each do |place_cases|
      database_client.exec_prepared(
        'insert_places_cases',
        [
          place_cases.place_id, place_cases.infected, place_cases.cured,
          place_cases.fatal, place_cases.timestamp
        ]
      )
    end
  end

  private

  def prepare_find_latest_places_cases_by_country_id_statement
    database_client.prepare(
      'find_latest_places_cases_by_country_id',
      'select * from covid19.latest_places_cases lpc where lpc.country_id = $1'
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end

  def prepare_insert_places_cases_statement
    database_client.prepare(
      'insert_places_cases',
      '
        insert into covid19.places_cases
        (place_id, infected, cured, fatal, timestamp)
        values ($1, $2, $3, $4, $5)
      '
    )
  end
end
