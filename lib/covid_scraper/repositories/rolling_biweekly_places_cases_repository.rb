# frozen_string_literal: true

module CovidScraper
  module Repositories
    class RollingBiweeklyPlacesCasesRepository < ROM::Repository[:rolling_biweekly_places_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        rolling_biweekly_places_cases.to_a
      end

      def by_country_name(country_name)
        rolling_biweekly_places_cases.where(country: country_name)
      end
    end
  end
end
