# frozen_string_literal: true

module CovidScraper
  module Workers
    class ScrapeCasesAgeWorker
      include Import['container']
      include Import['repositories.cases_age_repository']
      include Import['repositories.countries_repository']
      include Dry::Monads[:result]

      include ::Sidekiq::Worker

      sidekiq_options queue: :scraping, retry: 2, backtrace: true

      def perform(class_name, class_params = {})
        container.disconnect

        scraper_class = Object.const_get(class_name)
        scraper = scraper_class.new(class_params)

        country = countries_repository.by_name(scraper.country).first
        latest_cases_age = cases_age_repository.latest(country.id)
        scraped_cases_age = scraper.scrape(country.id)

        return if scraper.cases_match?(latest_cases_age, scraped_cases_age) ||
          !scraper.new_data?(latest_cases_age, scraped_cases_age)

        create_case_age(scraped_cases_age.to_h, scraper.country)
      end

      private

      def create_case_age(input, country_name)
        create_case_age = CovidScraper::Transactions::CasesAge::CreateCaseAge.new
        result = create_case_age.call(input)
        case result
        when Success
          ExportCasesAgeDatasetsWorker.perform_async(country_name)
        when Failure(Dry::Validation::Result)
          errors = result.failure.errors.to_h
          raise "An error occurred when creating case age: #{errors}"
        end
      end
    end
  end
end
