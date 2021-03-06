# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DateDiffPlacesCasesRepository < ROM::Repository[:date_diff_places_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_diff_places_cases.to_a
      end

      def by_place_name(place_name)
        date_diff_places_cases.where(place: place_name)
      end
    end
  end
end
