# frozen_string_literal: true

module CovidScraper
  module Workers
    class ExportPlacesJsonWorker
      include Import['repositories.latest_places_cases_repository']
      include Import['repositories.countries_repository']

      include FileHelpers

      include ::Sidekiq::Worker
      sidekiq_options retry: 2, backtrace: true

      PLACES_CASES_FILENAME = 'GeoDataset.json'

      def perform(country_name)
        country = countries_repository.by_name(country_name).first

        write_file(
          filename: build_database_file_path(country.name, PLACES_CASES_FILENAME),
          data: latest_places_cases_repository
                  .by_country_id(country.id)
                  .map_with(:latest_places_cases_mapper)
                  .to_a
                  .reduce(&:merge)
                  .to_json
        )

        PublishDatasetsWorker.perform_async
      end
    end
  end
end
