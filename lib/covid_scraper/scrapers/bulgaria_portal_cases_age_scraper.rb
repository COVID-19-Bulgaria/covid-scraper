# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaPortalCasesAgeScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://coronavirus.bg/bg/statistika'
      STATISTICS_CONTAINER_CSS = 'div.main-content'
      CASES_AGE_CSS = 'div:nth-child(1) > table > tbody > tr'
      CASES_AGE_GROUP_CSS = 'td:first-child'
      CASES_AGE_CASES_CSS = 'td:nth-child(2)'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def scrape(country_id)
        CovidScraper::Entities::CasesAgeEntity.new(
          country_id: country_id,
          group_0_1: cases_age['0_1'],
          group_1_5: cases_age['1_5'],
          group_6_9: cases_age['6_9'],
          group_10_14: cases_age['10_14'],
          group_15_19: cases_age['15_19'],
          group_0_19: cases_age['0_19'],
          group_20_29: cases_age['20_29'],
          group_30_39: cases_age['30_39'],
          group_40_49: cases_age['40_49'],
          group_50_59: cases_age['50_59'],
          group_60_69: cases_age['60_69'],
          group_70_79: cases_age['70_79'],
          group_80_89: cases_age['80_89'],
          group_90: cases_age['90'],
          timestamp: Time.now
        )
      end

      def cases_match?(first, second)
        first.country_id == second.country_id &&
          first.group_0_1 == second.group_0_1 &&
          first.group_1_5 == second.group_1_5 &&
          first.group_6_9 == second.group_6_9 &&
          first.group_10_14 == second.group_10_14 &&
          first.group_15_19 == second.group_15_19 &&
          first.group_0_19 == second.group_0_19 &&
          first.group_20_29 == second.group_20_29 &&
          first.group_30_39 == second.group_30_39 &&
          first.group_40_49 == second.group_40_49 &&
          first.group_50_59 == second.group_50_59 &&
          first.group_60_69 == second.group_60_69 &&
          first.group_70_79 == second.group_70_79 &&
          first.group_80_89 == second.group_80_89 &&
          first.group_90 == second.group_90 &&
          Date.parse(first.timestamp.to_s) == Date.parse(second.timestamp.to_s)
      end

      def new_data?(latest_cases, scraped_cases)
        latest_cases.group_0_1 != scraped_cases.group_0_1 ||
          latest_cases.group_1_5 != scraped_cases.group_1_5 ||
          latest_cases.group_6_9 != scraped_cases.group_6_9 ||
          latest_cases.group_10_14 != scraped_cases.group_10_14 ||
          latest_cases.group_15_19 != scraped_cases.group_15_19 ||
          latest_cases.group_0_19 != scraped_cases.group_0_19 ||
          latest_cases.group_20_29 != scraped_cases.group_20_29 ||
          latest_cases.group_30_39 != scraped_cases.group_30_39 ||
          latest_cases.group_40_49 != scraped_cases.group_40_49 ||
          latest_cases.group_50_59 != scraped_cases.group_50_59 ||
          latest_cases.group_60_69 != scraped_cases.group_60_69 ||
          latest_cases.group_70_79 != scraped_cases.group_70_79 ||
          latest_cases.group_80_89 != scraped_cases.group_80_89 ||
          latest_cases.group_90 != scraped_cases.group_90
      end

      private

      def statistics_container
        @statistics_container ||= parse.css(STATISTICS_CONTAINER_CSS)
      end

      def cases_age
        return @cases_age if @cases_age

        raw_cases_age_cases = statistics_container.css(CASES_AGE_CSS)

        raise CovidScraper::Scrapers::Exceptions::ArticleSegmentationError.new(field: 'cases_age') if !raw_cases_age_cases || raw_cases_age_cases.empty?

        cases_age_hash = {}

        raw_cases_age_cases.each_with_index do |cases_age, i|
          break if i == raw_cases_age_cases.count - 1

          group = cases_age.css(CASES_AGE_GROUP_CSS).text.gsub(' - ', '_').gsub('+','')

          cases = cases_age.css(CASES_AGE_CASES_CSS).text.to_i

          cases_age_hash[group] = cases
        end

        @cases_age = cases_age_hash
      end
    end
  end
end
