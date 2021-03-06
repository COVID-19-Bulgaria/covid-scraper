# frozen_string_literal: true

require 'csv'

module CovidScraper
  module Mappers
    class CsvMapper < ROM::Transformer
      register_as :csv_mapper


      def call(data)
        CSV.generate do |csv|
          csv << data.first.attributes.keys
          
          data.each do |entry|
            csv << entry.attributes.values
          end
        end
      end
    end
  end
end
