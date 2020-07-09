# frozen_string_literal: true

module CovidScraper
  module Repositories
    class DatePositiveTestsRepository < ROM::Repository[:date_positive_tests]
      include Import['container']
      struct_namespace CovidScraper

      def all
        date_positive_tests.to_a
      end

      def by_country_name(country_name)
        date_positive_tests.where(country: country_name)
      end
    end
  end
end
