# frozen_string_literal: true

module CovidScraper
  module Repositories
    class WeekPlacesCasesRepository < ROM::Repository[:week_places_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        week_places_cases.to_a
      end

      def by_place_name(place_name)
        week_places_cases.where(place: place_name)
      end
    end
  end
end
