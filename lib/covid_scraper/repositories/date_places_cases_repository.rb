# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DatePlacesCasesRepository < ROM::Repository[:date_places_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_places_cases.to_a
      end

      def by_country_name(country_name)
        date_places_cases.where(country: country_name)
      end
    end
  end
end
