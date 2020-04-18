# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI =
        'https://www.mh.government.bg/bg/informaciya-za-grazhdani/' \
        'potvrdeni-sluchai-na-koronavirus-na-teritoriyata-na-r-blgariya/'
      INFECTED_CONTAINER_XPATH =
        '//*[@id="top"]/div/div/div[1]/table/tbody/tr[1]/td[2]/p/span'
      CURED_CONTAINER_XPATH =
        '//*[@id="top"]/div/div/div[1]/table/tbody/tr[3]/td[2]/span'
      FATAL_CONTAINER_XPATH =
        '//*[@id="top"]/div/div/div[1]/table/tbody/tr[2]/td[2]/span'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def infected
        parse.xpath(INFECTED_CONTAINER_XPATH).text
      end

      def cured
        parse.xpath(CURED_CONTAINER_XPATH).text
      end

      def fatal
        parse.xpath(FATAL_CONTAINER_XPATH).text
      end

      def scrape(country_id)
        Case.new(
          country_id: country_id,
          infected: infected,
          cured: cured,
          fatal: fatal,
          timestamp: Time.now
        )
      end

      def cases_match(first, second)
        first.country_id == second.country_id &&
          first.infected == second.infected &&
          first.cured == second.cured &&
          first.fatal == second.fatal &&
          Date.parse(first.timestamp.to_s) == Date.parse(second.timestamp.to_s)
      end
    end
  end
end
