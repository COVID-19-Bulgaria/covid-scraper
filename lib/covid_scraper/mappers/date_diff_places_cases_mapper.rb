# frozen_string_literal: true

require_relative './csv_mapper'

module CovidScraper
  module Mappers
    class DateDiffPlacesCasesMapper < CsvMapper
      relation :date_diff_places_cases
      register_as :csv_mapper
    end
  end
end
