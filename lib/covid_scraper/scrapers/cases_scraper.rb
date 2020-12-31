# frozen_string_literal: true

module CovidScraper
  module Scrapers
    class CasesScraper
      attr_reader :country
      attr_reader :uri

      def initialize(country:, uri:)
        @country = country
        @uri = uri
      end

      def parse
        @parse ||= Nokogiri::HTML(fetch_page)
      end

      def infected
        raise 'Override with actual implementation.'
      end

      def cured
        raise 'Override with actual implementation.'
      end

      def fatal
        raise 'Override with actual implementation.'
      end

      def vaccinated
        raise 'Override with actual implementation.'
      end

      def men
        raise 'Override with actual implementation.'
      end

      def women
        raise 'Override with actual implementation.'
      end

      def hospitalized
        raise 'Override with actual implementation.'
      end

      def intensive_care
        raise 'Override with actual implementation.'
      end

      def medical_staff
        raise 'Override with actual implementation.'
      end

      def regions_cases
        raise 'Override with actual implementation.'
      end

      def pcr_tests
        raise 'Override with actual implementation'
      end

      def antigen_tests
        raise 'Override with actual implementation'
      end

      def scrape(country_id)
        CovidScraper::Entities::Case.new(
          country_id: country_id,
          infected: infected,
          cured: cured,
          fatal: fatal,
          men: men,
          women: women,
          hospitalized: hospitalized,
          intensive_care: intensive_care,
          medical_staff: medical_staff,
          pcr_tests: pcr_tests,
          antigen_tests: antigen_tests,
          vaccinated: vaccinated,
          timestamp: Time.now
        )
      end

      def cases_match?(first, second)
        first.country_id == second.country_id &&
          first.infected == second.infected &&
          first.cured == second.cured &&
          first.fatal == second.fatal &&
          first.men == second.men &&
          first.women == second.women &&
          first.hospitalized == second.hospitalized &&
          first.intensive_care == second.intensive_care &&
          first.medical_staff == second.medical_staff &&
          first.pcr_tests == second.pcr_tests &&
          first.antigen_tests == second.antigen_tests &&
          first.vaccinated == second.vaccinated &&
          Date.parse(first.timestamp.to_s) == Date.parse(second.timestamp.to_s)
      end

      def new_data?(latest_cases, scraped_cases)
        latest_cases.infected < scraped_cases.infected ||
          latest_cases.cured < scraped_cases.cured ||
          latest_cases.fatal < scraped_cases.fatal ||
          # latest_cases.men < scraped_cases.men ||
          # latest_cases.women < scraped_cases.women ||
          latest_cases.hospitalized != scraped_cases.hospitalized ||
          latest_cases.intensive_care != scraped_cases.intensive_care ||
          latest_cases.medical_staff != scraped_cases.medical_staff ||
          latest_cases.pcr_tests < scraped_cases.pcr_tests ||
          latest_cases.antigen_tests < scraped_cases.antigen_tests ||
          latest_cases.vaccinated < scraped_cases.vaccinated
      end

      private

      def fetch_page
        URI.open(uri)
      end
    end
  end
end
