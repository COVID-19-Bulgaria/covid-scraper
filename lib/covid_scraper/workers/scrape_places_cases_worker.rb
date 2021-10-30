# frozen_string_literal: true

module CovidScraper
  module Workers
    class ScrapePlacesCasesWorker
      include Import['container']
      include Import['repositories.latest_places_cases_repository']
      include Import['repositories.countries_repository']
      include Import['transactions.places_cases.create_places_case']
      include Dry::Monads[:result]

      include ::Sidekiq::Worker

      sidekiq_options queue: :scraping, retry: 0, backtrace: true

      def perform(class_name, class_params = {})
        container.disconnect

        scraper_class = Object.const_get(class_name)
        scraper = scraper_class.new(class_params)

        country = countries_repository.by_name(scraper.country).first
        regions_data_hash = build_regions_data_hash(scraper.regions_cases, scraper.regions_vaccinations)

        return unless update_places_cases(country.id,
                                          regions_data_hash,
                                          class_params[:website_uri])

        ExportPlacesDatasetsWorker.perform_async(scraper.country)
      end

      private

      def build_regions_data_hash(cases_hash, vaccinations_hash)
        regions_data_hash = cases_hash

        regions_data_hash.each do |region, region_cases_hash|
          region_vaccinations_hash = vaccinations_hash[region]
          next if region_vaccinations_hash.nil? or not region_vaccinations_hash.is_a?(Hash)

          regions_data_hash[region] = region_cases_hash.merge(region_vaccinations_hash)
        end

        regions_data_hash
      end

      def insert_places_case(places_case)
        result = create_places_case.call(places_case)
        case result
        when Failure(Dry::Validation::Result)
          errors = result.failure.errors.to_h
          raise "An error occurred when creating case: #{errors}"
        end
      end

      def update_places_cases(country_id, regions_data_hash, sources = nil)
        has_changed = false

        regions_data_hash.each do |region, data|
          latest_place_cases = latest_places_cases_repository
                               .by_country_id_and_name(country_id, region)

          next unless latest_place_cases &&
            (latest_place_cases.infected != data[:infected] ||
              latest_place_cases.doses != data[:doses] ||
              latest_place_cases.fully_vaccinated != data[:fully_vaccinated] ||
              latest_place_cases.booster != data[:booster])

          insert_places_case(
            {
              place_id: latest_place_cases.place_id,
              infected: data[:infected],
              doses: data[:doses],
              fully_vaccinated: data[:fully_vaccinated],
              booster: data[:booster],
              sources: sources,
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
