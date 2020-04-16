# frozen_string_literal: true

module CovidScraper
  module Workers
    class ScrapePlacesCasesWorker
      include Import['repositories.latest_places_cases_repository']
      include Import['repositories.countries_repository']
      include Import['transactions.places_cases.create_places_case']
      include Dry::Monads[:result]

      include ::Sidekiq::Worker

      sidekiq_options queue: :scraping, retry: 0, backtrace: true

      def perform(class_name)
        scraper_class = Object.const_get(class_name)
        scraper = scraper_class.new

        country = countries_repository.by_name(scraper.country).first
        scraped_places_cases = scraper.regions_cases

        return unless update_places_cases(country.id, scraped_places_cases)

        ExportPlacesJsonWorker.perform_async(scraper.country)
      end

      private

      def insert_places_case(places_case)
        result = create_places_case.call(places_case)
        case result
        when Failure(Dry::Validation::Result)
          errors = result.failure.errors.to_h
          raise "An error occurred when creating case: #{errors}"
        end
      end

      def update_places_cases(country_id, scraped_places_cases)
        has_changed = false

        scraped_places_cases.each do |place, cases|
          latest_place_cases = latest_places_cases_repository
                               .by_country_id_and_name(country_id, place)

          next unless latest_places_cases &&
                      latest_places_cases.infected != cases

          insert_places_case(
            {
              place_id: latest_place_cases.place_id,
              infected: cases,
              cured: latest_place_cases.cured,
              fatal: latest_place_cases.fatal,
              timestamp: Time.now
            }
          )

          has_changed = true
        end

        has_changed
      end
    end
  end
end
