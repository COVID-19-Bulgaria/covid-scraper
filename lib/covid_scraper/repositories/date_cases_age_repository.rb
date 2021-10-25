# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DateCasesAgeRepository < ROM::Repository[:date_cases_age]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_cases_age.to_a
      end

      def by_country_name(country_name)
        date_cases_age.where(country: country_name)
      end
    end
  end
end
