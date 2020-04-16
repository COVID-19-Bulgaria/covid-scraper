# frozen_string_literal: true

module CovidScraper
  module Workers
    class ScrapeCasesWorker
      include Import['repositories.cases_repository']
      include Import['repositories.countries_repository']
      include Dry::Monads[:result]

      include ::Sidekiq::Worker

      sidekiq_options queue: :scraping, retry: 2, backtrace: true

      def perform(class_name)
        scraper_class = Object.const_get(class_name)
        scraper = scraper_class.new

        country = countries_repository.by_name(scraper.country).first
        latest_cases = cases_repository.latest(country.id)
        scraped_cases = scraper.scrape(country.id)

        return if scraper.cases_match(latest_cases, scraped_cases)

        create_case(scraped_cases.to_h, scraper.country)
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
    end
  end
end
