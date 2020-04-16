# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DateCasesMapper < ROM::Transformer
      relation :date_cases
      register_as :json_mapper

      def call(cases)
        document = { infected: {}, cured: {}, fatal: {} }

        cases.each do |date_cases|
          document[:infected].merge!({
                                       date_cases.date => {
                                         cases: date_cases.infected
                                       }
                                     })

          document[:cured].merge!({
                                    date_cases.date => {
                                      cases: date_cases.cured
                                    }
                                  })

          document[:fatal].merge!({
                                    date_cases.date => {
                                      cases: date_cases.fatal
                                    }
                                  })
        end

        document
      end
    end
  end
end
