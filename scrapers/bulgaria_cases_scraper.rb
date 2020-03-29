# frozen_string_literal: true

require_relative './cases_scraper'

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

  def initialize
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
end
