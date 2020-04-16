# frozen_string_literal: true

module CovidScraper
  module Repositories
    class PlacesCasesRepository < ROM::Repository[:places_cases]
      include Import['container']
      struct_namespace CovidScraper

      commands :create,
        use: :timestamps,
        plugins_options: {
          timestamps: {
            timestamps: %i(timestamp)
          }
        }

      def all
        places_cases.to_a
      end
    end
  end
end
