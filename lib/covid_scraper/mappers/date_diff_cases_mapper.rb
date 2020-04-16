# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DateDiffCasesMapper < DateCasesMapper
      relation :date_diff_cases
      register_as :json_mapper
    end
  end
end
