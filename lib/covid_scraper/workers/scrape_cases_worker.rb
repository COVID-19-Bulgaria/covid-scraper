# frozen_string_literal: true

module CovidScraper
  module Workers
    class ScrapeCasesWorker
      include Import['repositories.cases_repository']
      include Import['repositories.countries_repository']
      include Dry::Monads[:result]

      include ::Sidekiq::Worker

      sidekiq_options queue: :scraping, retry: 2, backtrace: true

      def perform(class_name, class_params = {})
        scraper_class = Object.const_get(class_name)
        scraper = scraper_class.new(class_params)

        country = countries_repository.by_name(scraper.country).first
        latest_cases = cases_repository.latest(country.id)
        scraped_cases = scraper.scrape(country.id)

        return if scraper.cases_match?(latest_cases, scraped_cases) ||
                  !scraper.new_data?(latest_cases, scraped_cases)

        cases_input = fill_missing_data_with_latest_known(
          latest_cases, scraped_cases
        ).to_h

        create_case(cases_input, scraper.country)
      end

      private

      def create_case(input, country_name)
        create_case = CovidScraper::Transactions::Cases::CreateCase.new
        result = create_case.call(input)
        case result
        when Success
          ExportCasesJsonWorker.perform_async(country_name)
        when Failure(Dry::Validation::Result)
          errors = result.failure.errors.to_h
          raise "An error occurred when creating case: #{errors}"
        end
      end

      def fill_missing_data_with_latest_known(latest_known, scraped_cases)
        CovidScraper::Entities::Case.new(
          latest_known.attributes
                      .filter { |key, _| !%i[id timestamp].include?(key) }
                      .merge(scraped_cases.attributes)
        )
      end
    end
  end
end
