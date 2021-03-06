# frozen_string_literal: true

require_relative './csv_mapper'

module CovidScraper
  module Mappers
    class WeekCasesMapper < CsvMapper
      relation :week_cases
      register_as :csv_mapper
    end
  end
end
