# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DateDiffCasesRepository < ROM::Repository[:date_diff_cases]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_diff_cases.to_a
      end

      def by_country_name(country_name)
        date_cases.where(country: country_name)
      end
    end
  end
end
