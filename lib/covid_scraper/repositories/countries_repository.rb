# frozen_string_literal: true

module CovidScraper
  module Repositories
    class CountriesRepository < ROM::Repository[:countries]
      include Import['container']
      struct_namespace CovidScraper

      def all
        countries.to_a
      end

      def by_name(name)
        countries.where(name: name)
      end
    end
  end
end
