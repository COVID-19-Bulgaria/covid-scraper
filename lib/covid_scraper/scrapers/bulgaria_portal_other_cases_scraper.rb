# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalOtherCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg/bg/statistika'
      STATISTICS_CONTAINER_CSS = 'div.main-content'
      MEDICAL_STAFF_CSS = 'div:nth-child(1) > table:nth-child(6) > tbody > tr:last-child > td:last-child'
      PCR_TESTS_CSS = 'div:nth-child(1) > div.col.stats.double > table:nth-child(3) > tbody > tr:nth-child(1) > td:nth-child(2)'
      ANTIGEN_TESTS_CSS = 'div:nth-child(1) > div.col.stats.double > table:nth-child(3) > tbody > tr:nth-child(2) > td:nth-child(2)'
      REGIONS_CASES_CSS = 'div:nth-child(2) > table > tbody > tr'
      REGIONS_CASES_REGION_CSS = 'td:first-child'
      REGIONS_CASES_CASES_CSS = 'td:nth-child(2)'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def medical_staff
        get_raw_text(MEDICAL_STAFF_CSS, 'medical_staff', statistics_container)
      end

      def pcr_tests
        get_raw_text(PCR_TESTS_CSS, 'pcr_tests', statistics_container)
      end

      def antigen_tests
        get_raw_text(ANTIGEN_TESTS_CSS, 'antigen_tests', statistics_container)
      end

      def regions_cases
        raw_regions_cases = statistics_container.css(REGIONS_CASES_CSS)

        raise ArticleSegmentationError.new(field: 'regions_cases') if !raw_regions_cases || raw_regions_cases.empty?

        regions_cases_hash = {}

        raw_regions_cases.each_with_index do |region_cases, i|
          break if i == raw_regions_cases.count - 1

          region = region_cases.css(REGIONS_CASES_REGION_CSS).text

          cases = region_cases.css(REGIONS_CASES_CASES_CSS).text.to_i

          regions_cases_hash[region] = cases
        end

        regions_cases_hash['София'] += regions_cases_hash.delete('София (столица)')

        regions_cases_hash
      end

      private

      def statistics_container
        @statistics_container ||= parse.css(STATISTICS_CONTAINER_CSS)
      end

      def get_raw_text(selector, field_name, container = statistics_container)
        raw_cases = container.css(selector).text

        raise ArticleSegmentationError.new(field: field_name) if !raw_cases || raw_cases.empty?

        raw_cases
      end
    end
  end
end
