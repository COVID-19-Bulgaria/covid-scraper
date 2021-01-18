# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalHomepageCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg'
      STATISTICS_CONTAINER_CSS = 'div.statistics-container'
      INFECTED_CSS = 'p.confirmed'
      CURED_CSS = 'p.healed'
      FATAL_CSS = 'p.deceased'
      VACCINATED_CSS = 'div:nth-child(6) > p.statistics-value'
      HOSPITALIZED_CSS = 'div:nth-child(4) > p.statistics-value'
      INTENSIVE_CARE_CSS = 'div:nth-child(4) > p.statistics-subvalue'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)

        @other_cases_scraper = BulgariaPortalOtherCasesScraper.new({})
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

      def vaccinated
        get_raw_text(VACCINATED_CSS, 'vaccinated')
      end

      def hospitalized
        get_raw_text(HOSPITALIZED_CSS, 'hospitalized')
      end

      def intensive_care
        get_raw_text(INTENSIVE_CARE_CSS, 'intensive_care')
      end

      def medical_staff
        @other_cases_scraper.medical_staff
      end

      def pcr_tests
        @other_cases_scraper.pcr_tests
      end

      def antigen_tests
        @other_cases_scraper.antigen_tests
      end

      def regions_cases
        @other_cases_scraper.regions_cases
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

      def get_raw_text(selector, field_name, container = statistics_container)
        raw_cases = container.css(selector).text

        raise CovidScraper::Scrapers::Exceptions::ArticleSegmentationError.new(field: field_name) if !raw_cases || raw_cases.empty?

        raw_cases
      end
    end
  end
end
