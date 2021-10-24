# frozen_string_literal: true

module CovidScraper
  module Mappers
    class CsvMapper < ROM::Transformer
      register_as :csv_mapper

      def call(data)
        csv_data = []

        csv_data << data.first.attributes.keys

        data.each do |entry|
          csv_data << entry.attributes.values
        end

        csv_data
      end
    end
  end
end
