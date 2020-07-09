# frozen_string_literal: true

module CovidScraper
  module Mappers
    class DatePositiveTestsMapper < ROM::Transformer
      relation :date_positive_tests
      register_as :json_mapper

      def call(data)
        document = {}

        data.each do |item|
          document.merge!({
                           item.date => {
                             percentage: item.positive_percentage.to_f
                           }
                         })
        end

        document
      end
    end
  end
end
