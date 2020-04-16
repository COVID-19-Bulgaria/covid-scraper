# frozen_string_literal: true

module CovidScraper
  module Repositories
    class LatestPlacesCasesRepository < ROM::Repository[:latest_places_cases]
      include Import['container']
      struct_namespace CovidScraper

      def by_country_id(country_id)
        latest_places_cases.where(country_id: country_id)
      end

      def by_country_id_and_name(country_id, name)
        latest_places_cases.where(country_id: country_id, name: name).first
      end
    end
  end
end
