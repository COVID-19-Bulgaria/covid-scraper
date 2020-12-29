# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg/bg/statistika'
      STATISTICS_CONTAINER_CSS = 'div.statistics-container'
      OTHER_STATISTICS_CONTAINER_CSS = 'div.main-content'
      INFECTED_CSS = 'p.confirmed'
      CURED_CSS = 'p.healed'
      FATAL_CSS = 'p.deceased'
      HOSPITALIZED_CSS = 'div:nth-child(4) > p.statistics-value'
      INTENSIVE_CARE_CSS = 'div:nth-child(4) > p.statistics-subvalue'
      MEDICAL_STAFF_CSS = 'div:nth-child(4) > table > tbody > tr:last-child > td:last-child'
      PCR_TESTS_CSS = 'div:nth-child(3) > table:nth-child(3) > tbody > tr:nth-child(1) > td:nth-child(2)'
      ANTIGEN_TESTS_CSS = 'div:nth-child(3) > table:nth-child(3) > tbody > tr:nth-child(2) > td:nth-child(2)'
      REGIONS_CASES_CSS = 'div:nth-child(2) > table > tbody > tr'
      REGIONS_CASES_REGION_CSS = 'td:first-child'
      REGIONS_CASES_CASES_CSS = 'td:nth-child(2)'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def infected
        get_raw_text(INFECTED_CSS, 'infected')
      end

      def cured
        get_raw_text(CURED_CSS, 'cured')
      end

      def fatal
        get_raw_text(FATAL_CSS, 'fatal')
      end

      def hospitalized
        get_raw_text(HOSPITALIZED_CSS, 'hospitalized')
      end

      def intensive_care
        get_raw_text(INTENSIVE_CARE_CSS, 'intensive_care')
      end

      def medical_staff
        get_raw_text(MEDICAL_STAFF_CSS, 'medical_staff', other_statistics_container)
      end

      def pcr_tests
        get_raw_text(PCR_TESTS_CSS, 'pcr_tests', other_statistics_container)
      end

      def antigen_tests
        get_raw_text(ANTIGEN_TESTS_CSS, 'antigen_tests', other_statistics_container)
      end

      def regions_cases
        raw_regions_cases = other_statistics_container.css(REGIONS_CASES_CSS)

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

      def men
        nil
      end

      def women
        nil
      end

      private

      def statistics_container
        @statistics_container ||= parse.css(STATISTICS_CONTAINER_CSS)
      end

      def other_statistics_container
        @other_statistics_container ||= parse.css(OTHER_STATISTICS_CONTAINER_CSS)
      end

      def get_raw_text(selector, field_name, container = statistics_container)
        raw_cases = container.css(selector).text

        raise ArticleSegmentationError.new(field: field_name) if !raw_cases || raw_cases.empty?

        raw_cases
      end
    end
  end
end
