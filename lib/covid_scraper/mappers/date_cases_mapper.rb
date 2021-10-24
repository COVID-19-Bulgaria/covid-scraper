# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DateCasesMapper < ROM::Transformer
      relation :date_cases
      register_as :json_mapper

      def call(cases)
        data_points = %i[infected cured fatal hospitalized intensive_care
                         medical_staff pcr_tests positive_pcr_tests antigen_tests positive_antigen_tests
                         vaccinated].freeze

        document = {}
        data_points.each { |point| document[point] = {} }

        cases.each do |date_cases|
          data_points.each do |point|
            document[point].merge!({
                                     date_cases.date => {
                                       cases: date_cases.send(point)
                                     }
                                   })
          end
        end

        document
      end
    end
  end
end
