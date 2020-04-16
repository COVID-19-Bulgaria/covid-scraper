# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DateCasesRepository < ROM::Repository[:date_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_cases.to_a
      end

      def by_country_name(country_name)
        date_cases.where(country: country_name)
      end
    end
  end
end
