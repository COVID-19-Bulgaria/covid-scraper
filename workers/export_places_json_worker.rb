# frozen_string_literal: true

require_relative '../helpers/file_helpers'
require_relative '../helpers/database_helpers'
require_relative '../repositories/places_repository'
require_relative '../repositories/country_repository'
require_relative '../models/place_cases'
require_relative '../models/country'
require_relative './publish_datasets_worker'

class ExportPlacesJsonWorker
  include FileHelpers
  include DatabaseHelpers

  include Sidekiq::Worker
  sidekiq_options retry: 2, backtrace: true

  PLACES_CASES_FILENAME = 'GeoDataset.json'

  def perform(country_name)
    country = find_country(country_name)

    write_file(
      filename: build_database_file_path(country.name, PLACES_CASES_FILENAME),
      data: latest_places_cases(country.id)
    )

    PublishDatasetsWorker.perform_async
  ensure
    database_client&.close
  end

  private

  def places_repository
    @places_repository ||= PlacesRepository.new(database_client)
  end

  def country_repository
    @country_repository ||= CountryRepository.new(database_client)
  end

  def latest_places_cases(country_id)
    places_repository.find_by_country_id(country_id).to_a
      .map { |row| PlaceCases.build(row) }
      .map(&:to_h)
      .reduce(&:merge)
      .to_json
  end

  def find_country(name)
    Country.build(country_repository.find_by_name(name).first)
  end
end
