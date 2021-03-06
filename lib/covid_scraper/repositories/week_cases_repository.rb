# frozen_string_literal: true

module CovidScraper
  module Repositories
    class WeekCasesRepository < ROM::Repository[:week_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        week_cases.to_a
      end

      def by_country_name(country_name)
        week_cases.where(country: country_name)
      end
    end
  end
end
