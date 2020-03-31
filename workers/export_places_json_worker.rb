# frozen_string_literal: true

require_relative '../db/database'
require_relative '../helpers/file_helpers'
require_relative '../helpers/database_helpers'
require_relative '../repositories/places_repository'
require_relative '../models/place_cases'
require_relative './publish_datasets_worker'

class ExportPlacesJsonWorker
  include FileHelpers
  include DatabaseHelpers

  include Sidekiq::Worker
  sidekiq_options retry: 2, backtrace: true

  PLACES_CASES_FILENAME = 'GeoDataset.json'

  # TODO: Places per country
  def perform
    write_file(
      filename: build_database_file_path('Bulgaria', PLACES_CASES_FILENAME),
      data: latest_places_cases
    )

    PublishDatasetsWorker.perform_async
  ensure
    database_client&.close
  end

  private

  def places_repository
    @places_repository ||= PlacesRepository.new(database_client)
  end

  def latest_places_cases
    places_repository.latest.to_a
      .map { |row| PlaceCases.build(row) }
      .map(&:to_h)
      .reduce(&:merge)
      .to_json
  end
end
