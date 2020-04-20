# frozen_string_literal: true

module CovidScraper
  module Workers
    class ExportCasesJsonWorker
      include Import['container']
      include Import['repositories.countries_repository']
      include Import['repositories.cases_repository']
      include Import['repositories.date_cases_repository']
      include Import['repositories.date_diff_cases_repository']

      include FileHelpers

      include ::Sidekiq::Worker
      sidekiq_options retry: 2, backtrace: true

      TOTALS_DATASET_FILENAME = 'TotalsDataset.json'
      DATE_CASES_FILENAME = 'DateCasesDataset.json'
      DATE_DIFF_CASES_FILENAME = 'DateDiffCasesDataset.json'

      def perform(country_name)
        container.disconnect

        country = countries_repository.by_name(country_name).first

        write_file(
          filename: build_database_file_path(country.name, TOTALS_DATASET_FILENAME),
          data: cases_repository.latest(country.id).to_h.to_json
        )

        write_file(
          filename: build_database_file_path(country.name, DATE_CASES_FILENAME),
          data: Hash[
                  date_cases_repository
                    .by_country_name(country.name)
                    .map_with(:json_mapper)
                    .to_a
                ].to_json
        )

        write_file(
          filename: build_database_file_path(country.name, DATE_DIFF_CASES_FILENAME),
          data: Hash[
                  date_diff_cases_repository
                    .by_country_name(country.name)
                    .map_with(:json_mapper)
                    .to_a
                ].to_json
        )

        PublishDatasetsWorker.perform_async
      end
    end
  end
end
