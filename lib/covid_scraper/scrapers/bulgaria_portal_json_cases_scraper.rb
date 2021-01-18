# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalJsonCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg/stats.json'     

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def parse
        @parse ||= JSON.parse(fetch_page)
      end

      def infected
        parse['infected']
      end

      def cured
        parse['healed']
      end

      def fatal
        parse['died']
      end

      def vaccinated
        nil
      end

      def hospitalized
        parse['hospitalized']
      end

      def intensive_care
        parse['hospitalized_intensive']
      end

      def medical_staff
        nil
      end

      def pcr_tests
        parse['tested_pcr']
      end

      def antigen_tests
        parse['tested_antigen']
      end

      def regions_cases
        nil
      end

      def men
        nil
      end

      def women
        nil
      end
    end
  end
end
