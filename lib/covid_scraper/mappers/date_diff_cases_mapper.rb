# frozen_string_literal: true

require_relative './date_cases_mapper'

module CovidScraper
  module Mappers
    class DateDiffCasesMapper < DateCasesMapper
      relation :date_diff_cases
      register_as :json_mapper
    end
  end
end
