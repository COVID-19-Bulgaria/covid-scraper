# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaMhCasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      ARTICLE_CONTAINER_CSS = 'div.single_news'
      REGIONS_CASES_SEGMENT_NEEDLE = ';'

      def initialize(class_params)
        super(country: COUNTRY_IDENTIFIER, uri: class_params[:website_uri])
      end

      def regions_cases
        segment = fuzzy_match.find(REGIONS_CASES_SEGMENT_NEEDLE)

        raise ArticleSegmentationError.new(field: 'regions_cases') unless segment

        raw_pairs = segment.split(':')[1].split(';')
        regions_cases_hash = {}

        raw_pairs.each do |raw_pair|
          pair = raw_pair.split(/-|–/)

          regions_cases_hash[pair[0].strip] = pair[1].strip.to_i
        end

        regions_cases_hash
      end

      private

      def article_text
        @article_text ||= parse.css(ARTICLE_CONTAINER_CSS).text
      end

      def article_segments
        @article_segments ||= PragmaticSegmenter::Segmenter.new(text: article_text)
                                                           .segment
      end

      def fuzzy_match
        @fuzzy_match ||= FuzzyMatch.new(article_segments)
      end
    end
  end
end
