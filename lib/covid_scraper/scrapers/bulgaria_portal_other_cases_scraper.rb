# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalOtherCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg/bg/statistika'
      STATISTICS_CONTAINER_CSS = 'div.main-content'
      MEDICAL_STAFF_CSS = 'div:nth-child(3) > table > tbody > tr:last-child > td:last-child'
      PCR_TESTS_CSS = 'div:nth-child(1) > table:nth-child(6) > tbody > tr:nth-child(1) > td:nth-child(2)'
      POSITIVE_PCR_TESTS_CSS = 'div:nth-child(1) > table:nth-child(9) > tbody > tr:nth-child(1) > td:nth-child(2)'
      ANTIGEN_TESTS_CSS = 'div:nth-child(1) > table:nth-child(6) > tbody > tr:nth-child(2) > td:nth-child(2)'
      POSITIVE_ANTIGEN_TESTS_CSS = 'div:nth-child(1) > table:nth-child(9) > tbody > tr:nth-child(2) > td:nth-child(2)'
      REGIONS_CASES_CSS = 'div:nth-child(2) > table > tbody > tr'
      REGIONS_CASES_REGION_CSS = 'td:first-child'
      REGIONS_CASES_CASES_CSS = 'td:nth-child(2)'
      REGIONS_VACCINATIONS_VACCINE_TYPE_CSS = 'div:nth-child(1) > div.col.stats > table > thead > tr:nth-child(2) > th'
      REGIONS_VACCINATIONS_CSS = 'div:nth-child(1) > div.col.stats > table > tbody > tr'
      REGIONS_VACCINATIONS_REGION_CSS = 'td:first-child'
      REGIONS_VACCINATIONS_DOSES_CSS = 'td:nth-child(2)'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def medical_staff
        get_raw_text(MEDICAL_STAFF_CSS, 'medical_staff', statistics_container)
      end

      def pcr_tests
        get_raw_text(PCR_TESTS_CSS, 'pcr_tests', statistics_container)
      end

      def positive_pcr_tests
        get_raw_text(POSITIVE_PCR_TESTS_CSS, 'positive_pcr_tests', statistics_container)
      end

      def antigen_tests
        get_raw_text(ANTIGEN_TESTS_CSS, 'antigen_tests', statistics_container)
      end

      def positive_antigen_tests
        get_raw_text(POSITIVE_ANTIGEN_TESTS_CSS, 'positive_antigen_tests', statistics_container)
      end

      def regions_cases
        raw_regions_cases = statistics_container.css(REGIONS_CASES_CSS)

        raise CovidScraper::Scrapers::Exceptions::ArticleSegmentationError.new(field: 'regions_cases') if !raw_regions_cases || raw_regions_cases.empty?

        regions_cases_hash = {}

        raw_regions_cases.each_with_index do |region_cases, i|
          break if i == raw_regions_cases.count - 1

          region = region_cases.css(REGIONS_CASES_REGION_CSS).text

          cases = region_cases.css(REGIONS_CASES_CASES_CSS).text.to_i

          regions_cases_hash[region] = {
            infected: cases
          }
        end

        regions_cases_hash['София област'] = regions_cases_hash.delete('София')
        regions_cases_hash['София'] = regions_cases_hash.delete('София (столица)')

        regions_cases_hash
      end

      def regions_vaccinations
        raw_regions_vaccinations = statistics_container.css(REGIONS_VACCINATIONS_CSS)

        regions_vaccinations_hash = {}

        raw_regions_vaccinations.each_with_index do |region_row, i|
          break if i == raw_regions_vaccinations.count - 1

          region = region_row.css(REGIONS_VACCINATIONS_REGION_CSS).text
          doses = region_row.css(REGIONS_VACCINATIONS_DOSES_CSS).text.to_i
          fully_vaccinated = region_row.css(regions_vaccinations_fully_vaccinated_css).text.to_i
          booster = region_row.css(regions_vaccinations_booster_css).text.to_i

          regions_vaccinations_hash[region] = {
            doses: doses,
            fully_vaccinated: fully_vaccinated,
            booster: booster
          }
        end

        regions_vaccinations_hash['София област'] = regions_vaccinations_hash.delete('София')
        regions_vaccinations_hash['София'] = regions_vaccinations_hash.delete('София (столица)')

        raw_regions_vaccinations
      end

      private

      def statistics_container
        @statistics_container ||= parse.css(STATISTICS_CONTAINER_CSS)
      end

      def number_of_vaccine_types
        @number_of_vaccine_types ||= statistics_container.css(REGIONS_VACCINATIONS_VACCINE_TYPE_CSS)
      end

      def regions_vaccinations_fully_vaccinated_css
        # 2 columns followed by N vaccines columns + 1
        @regions_vaccinations_fully_vaccinated_css ||= "td:nth-child(#{2 + number_of_vaccine_types + 1})"
      end

      def regions_vaccinations_booster_css
        # 2 columns followed by N vaccines columns followed by 1 fully vaccinated column + 1
        @regions_vaccinations_booster_css ||= "td:nth-child(#{2 + number_of_vaccine_types + 1 + 1})"
      end

      def get_raw_text(selector, field_name, container = statistics_container)
        raw_cases = container.css(selector).text

        raise CovidScraper::Scrapers::Exceptions::ArticleSegmentationError.new(field: field_name) if !raw_cases || raw_cases.empty?

        raw_cases
      end
    end
  end
end
