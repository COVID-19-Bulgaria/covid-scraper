# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DatePositiveTestsMapper < CsvMapper
      relation :date_positive_tests
      register_as :csv_mapper
    end
  end
end
