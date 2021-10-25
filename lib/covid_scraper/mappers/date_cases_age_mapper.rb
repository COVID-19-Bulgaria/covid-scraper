# frozen_string_literal: true

require_relative './csv_mapper'

module CovidScraper
  module Mappers
    class DateCasesAgeMapper < CsvMapper
      relation :date_cases_age
      register_as :csv_mapper
    end
  end
end
