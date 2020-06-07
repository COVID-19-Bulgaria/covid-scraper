# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DateActiveCasesMapper < ROM::Transformer
      relation :date_active_cases
      register_as :json_mapper

      def call(cases)
        document = {
          active: {}
        }

        cases.each do |date_active_cases|
          document[:active].merge!({
                                     date_active_cases.date => {
                                       cases: date_active_cases.active
                                     }
                                   })
        end

        document
      end
    end
  end
end
