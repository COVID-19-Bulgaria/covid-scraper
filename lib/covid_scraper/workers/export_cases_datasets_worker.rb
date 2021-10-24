# frozen_string_literal: true

module CovidScraper
  module Workers
    class ExportCasesDatasetsWorker
      include Import['container']
      include Import['repositories.countries_repository']
      include Import['repositories.cases_repository']
      include Import['repositories.date_cases_repository']
      include Import['repositories.date_diff_cases_repository']
      include Import['repositories.date_active_cases_repository']
      include Import['repositories.date_positive_tests_repository']
      include Import['repositories.week_cases_repository']

      include FileHelpers

      include ::Sidekiq::Worker
      sidekiq_options retry: 2, backtrace: true

      TOTALS_DATASET_FILENAME = 'TotalsDataset.json'
      DATE_CASES_FILENAME = 'DateCasesDataset.json'
      DATE_DIFF_CASES_FILENAME = 'DateDiffCasesDataset.json'
      DATE_ACTIVE_CASES_FILENAME = 'DateActiveCasesDataset.json'
      DATE_POSITIVE_TESTS_FILENAME = 'DatePositiveTestsDataset.csv'
      WEEK_CASES_FILENAME = 'WeekCasesDataset.csv'

      def perform(country_name)
        container.disconnect

        country = countries_repository.by_name(country_name).first

        write_totals_dataset_file(country)
        write_date_cases_file(country)
        write_date_diff_cases_file(country)
        write_date_active_cases_file(country)
        write_positive_tests_file(country)
        write_week_cases_file(country)

        PublishDatasetsWorker.perform_async
      end

      private

      def write_totals_dataset_file(country)
        write_file(
          filename: build_database_file_path(country.name, TOTALS_DATASET_FILENAME),
          data: cases_repository.latest(country.id).to_h.to_json
        )
      end

      def write_date_cases_file(country)
        write_file(
          filename: build_database_file_path(country.name, DATE_CASES_FILENAME),
          data: Hash[
                  date_cases_repository
                    .by_country_name(country.name)
                    .map_with(:json_mapper)
                    .to_a
                ].to_json
        )
      end

      def write_date_diff_cases_file(country)
        write_file(
          filename: build_database_file_path(country.name, DATE_DIFF_CASES_FILENAME),
          data: Hash[
                  date_diff_cases_repository
                    .by_country_name(country.name)
                    .map_with(:json_mapper)
                    .to_a
                ].to_json
        )
      end

      def write_date_active_cases_file(country)
        write_file(
          filename: build_database_file_path(country.name, DATE_ACTIVE_CASES_FILENAME),
          data: Hash[
                  date_active_cases_repository
                    .by_country_name(country.name)
                    .map_with(:json_mapper)
                    .to_a
                ].to_json
        )
      end

      def write_positive_tests_file(country)
        write_file(
          filename: build_database_file_path(country.name, DATE_POSITIVE_TESTS_FILENAME),
          data: CSV.generate do |csv|
                  date_positive_tests_repository.by_country_name(country.name).map_with(:csv_mapper).to_a.each do |row|
                    csv << row
                  end
                end
        )
      end

      def write_week_cases_file(country)
        write_file(
          filename: build_database_file_path(country.name, WEEK_CASES_FILENAME),
          data: CSV.generate do |csv|
                  week_cases_repository.by_country_name(country.name).map_with(:csv_mapper).to_a.each do |row|
                    csv << row
                  end
                end
        )
      end
    end
  end
end
