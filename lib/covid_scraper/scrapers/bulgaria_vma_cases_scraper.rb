# frozen_string_literal: true

require_relative './cases_scraper'

module CovidScraper
  module Scrapers
    class BulgariaVMACasesScraper < CasesScraper
      COUNTRY_IDENTIFIER = 'Bulgaria'
      WEBSITE_URI = 'https://www.vma.bg/newsitem.html?action=news&newsid=842'
      ARTICLE_CONTAINER_CSS = 'div.right-side-page'
      INFECTED_SEGMENT_NEEDLE = 'потвърдени случаи covid-19'
      CURED_SEGMENT_NEEDLE = 'излекувани'
      FATAL_SEGMENT_NEEDLE = 'починали'
      MEN_SEGMENT_NEEDLE = 'всички мъже'
      WOMEN_SEGMENT_NEEDLE = 'всички жен'
      MEN = 'мъже'
      WOMEN = 'жени'
      HOSPITALIZED_SEGMENT_NEEDLE = 'настанен лекарско наблюдение'
      INTENSIVE_CARE_SEGMENT_NEEDLE = 'интензив'
      REGIONS_CASES_SEGMENT_NEEDLE = 'Регистрираните случаи по административни области са както следва ;'
      MEDICAL_STAFF_NEEDLE = 'медицински служители'

      def initialize(_class_params)
        super(country: COUNTRY_IDENTIFIER, uri: WEBSITE_URI)
      end

      def infected
        segment = fuzzy_match.find(INFECTED_SEGMENT_NEEDLE)

        raise ArticleSegmentationError.new(field: 'infected') unless segment

        find_number(segment: segment, type: :max)
      end

      def cured
        segment = fuzzy_match.find(CURED_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'cured') unless segment

        find_minimum_distance_number(
          segment: segment,
          needle: CURED_SEGMENT_NEEDLE
        )
      end

      def fatal
        segment = fuzzy_match.find(FATAL_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'fatal') unless segment

        find_minimum_distance_number(
          segment: segment,
          needle: FATAL_SEGMENT_NEEDLE
        )
      end

      def men
        segment = fuzzy_match.find(MEN_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'men') unless segment

        # Remove percentages from segment
        segment.gsub!(/\d+%/, '')

        find_minimum_distance_number(
          segment: segment,
          needle: MEN
        )
      end

      def women
        segment = fuzzy_match.find(WOMEN_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'women') unless segment

        # Remove percentages from segment
        segment.gsub!(/\d+%/, '')

        find_minimum_distance_number(
          segment: segment,
          needle: WOMEN
        )
      end

      def hospitalized
        segment = fuzzy_match.find(HOSPITALIZED_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'hospitalized') unless segment

        find_number(segment: segment, type: :max)
      end

      def intensive_care
        segment = fuzzy_match.find(INTENSIVE_CARE_SEGMENT_NEEDLE)
        raise ArticleSegmentationError.new(field: 'intensive_care') unless segment

        find_number(segment: segment, type: :min)
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

      def medical_staff
        segment = fuzzy_match.find(MEDICAL_STAFF_NEEDLE)
        raise ArticleSegmentationError.new(field: 'medical_staff') unless segment

        find_number(segment: segment, type: :max)
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

      def tokenizer
        @tokenizer ||= PragmaticTokenizer::Tokenizer.new(
          language: :bg,
          punctuation: :none
        )
      end

      def word_distance(array, word, count)
        word_index = nil
        count_index = nil

        array.each_with_index do |item, index|
          word_index = index if item.include?(word)
          count_index = index if item == count
        end

        (word_index - count_index).abs
      end

      def numbers_distance(numbers, tokens, word)
        numbers_distance = {}

        numbers.each do |number|
          numbers_distance[number.to_i] = word_distance(
            tokens,
            word,
            number
          )
        end

        numbers_distance
      end

      def find_minimum_distance_number(segment:, needle:)
        numbers = segment.scan(/\d+/)
        tokens = tokenizer.tokenize(segment)
        numbers_distance = numbers_distance(numbers, tokens, needle)

        minimum_distance_pair = numbers_distance.min_by { |_key, value| value }

        minimum_distance_pair[0]
      end

      def find_number(segment:, type:)
        numbers = segment.scan(/\d+/)
                         .map(&:to_i)
                         .filter { |number| number != 19 } # Skip COVID-19

        numbers.send(type)
      end
    end
  end
end
