# frozen_string_literal: true

require 'pragmatic_segmenter'
require 'pragmatic_tokenizer'
require 'fuzzy_match'
require_relative './exceptions/article_segmentation_error'

class BulgariaVMACasesScraper < CasesScraper
  COUNTRY_IDENTIFIER = 'Bulgaria'
  WEBSITE_URI = 'https://www.vma.bg/newsitem.html?action=news&newsid=842'
  ARTICLE_CONTAINER_XPATH = '/html/body/div[4]/div/div[2]/div/div[2]'
  INFECTED_SEGMENT_NEEDLE = 'потвърдени случаи covid-19'
  CURED_SEGMENT_NEEDLE = 'излекувани'
  FATAL_SEGMENT_NEEDLE = 'починали'
  MEN_SEGMENT_NEEDLE = 'мъже'
  WOMEN_SEGMENT_NEEDLE = 'жен'
  HOSPITALIZED_SEGMENT_NEEDLE = 'настанен лекарско наблюдение'
  INTENSIVE_CARE_SEGMENT_NEEDLE = 'интензив'
  REGIONS_CASES_SEGMENT_NEEDLE = 'адм обл'
  MEDICAL_STAFF_NEEDLE = 'медицински служители'

  def initialize
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
      needle: MEN_SEGMENT_NEEDLE
    )
  end

  def women
    segment = fuzzy_match.find(WOMEN_SEGMENT_NEEDLE)
    raise ArticleSegmentationError.new(field: 'women') unless segment

    # Remove percentages from segment
    segment.gsub!(/\d+%/, '')

    find_minimum_distance_number(
      segment: segment,
      needle: WOMEN_SEGMENT_NEEDLE
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
    # @article_text ||= parse.xpath(ARTICLE_CONTAINER_XPATH).text

    @article_text ||= '522 са общо случаите на COVID-19 у нас (актуална информация към 5 април, 08.00 часа)
05.04.2020


522 са потвърдените случаи на COVID-19 у нас по данни на Националния оперативен щаб. Броят на починалите е 18, а 37 са излекуваните.

Последните положителни проби са констатирани в София (13 случая), Стара Загора (3 случая), Бургас (1 случай), Перник (2 случая), Сливен (2 случая), Русе (1 случай), Пловдив (1 случай) и Кърджали (1 случай).

192 са лицата с потвърден COVID-19, които са настанени под лекарско наблюдение в болнични условия, като 26 от тях са в интензивни структури.

От всички 522 диагностицирани – 299 (57%) са мъже и 223 (43%) жени.

Най-възрастният пациент е на 86 години, а най-малкият – на 1 година.

Регистрираните случаи по административни области са както следва: Благоевград – 15; Бургас – 24; Варна – 24; Велико Търново – 4; Видин – 2; Враца – 1; Габрово – 2; Добрич – 11; Кърджали – 9; Кюстендил – 7; Ловеч – 2; Монтана – 18; Пазарджик – 10; Перник – 8; Плевен – 9; Пловдив – 30; Русе – 2; Силистра – 2; Сливен – 8; Смолян –13; София – 308; Стара Загора – 7; Хасково – 1; Шумен – 4.

Общият брой на потвърдените случаи на COVID-19 при лица-медицински служители е 23 души.

Снимка: ВМА'
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