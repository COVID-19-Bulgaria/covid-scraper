# frozen_string_literal: true

module CovidScraper
  module Workers
    class ExportCasesAgeDatasetsWorker
      include Import['container']
      include Import['repositories.countries_repository']
      include Import['repositories.date_cases_age_repository']

      include FileHelpers

      include ::Sidekiq::Worker
      sidekiq_options retry: 2, backtrace: true

      CASES_AGE_DATASET_FILENAME = 'CasesAgeDataset.csv'

      def perform(country_name)
        container.disconnect

        country = countries_repository.by_name(country_name).first

        write_cases_age_dataset_file(country)

        PublishDatasetsWorker.perform_async
      end

      private

      def write_cases_age_dataset_file(country)
        write_file(
          filename: build_database_file_path(country.name, CASES_AGE_DATASET_FILENAME),
          data: CSV.generate do |csv|
            date_cases_age_repository.by_country_name(country.name).map_with(:csv_mapper).to_a.each do |row|
              csv << row
            end
          end
        )
      end
    end
  end
end
