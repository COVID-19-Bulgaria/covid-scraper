# frozen_string_literal: true

module CovidScraper
  module Repositories
    class PlacesRepository < ROM::Repository[:places]
      include Import['container']
      struct_namespace CovidScraper

      def all
        places.to_a
      end
    end
  end
end
