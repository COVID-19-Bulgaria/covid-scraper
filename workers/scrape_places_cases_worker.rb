# frozen_string_literal: true

require_relative '../helpers/database_helpers'
require_relative '../repositories/places_repository'
require_relative '../repositories/country_repository'
require_relative '../scrapers/bulgaria_vma_cases_scraper'
require_relative '../models/place_cases'
require_relative '../models/country'
require_relative './export_places_json_worker'

class ScrapePlacesCasesWorker
  include Sidekiq::Worker
  include DatabaseHelpers

  sidekiq_options queue: :scraping, retry: 0, backtrace: true

  def perform(class_name)
    scraper_class = Object.const_get(class_name)
    scraper = scraper_class.new

    country = find_country(scraper.country)
    latest_places_cases = find_latest_places_cases(country.id)
    scraped_places_cases = scraper.regions_cases

    new_places_cases = build_places_cases(
      latest_places_cases,
      scraped_places_cases
    )

    return if new_places_cases.empty?

    places_repository.insert(new_places_cases)
    ExportPlacesJsonWorker.perform_async(scraper.country)
  ensure
    database_client&.close
  end

  private

  def country_repository
    @country_repository ||= CountryRepository.new(database_client)
  end

  def places_repository
    @places_repository ||= PlacesRepository.new(database_client)
  end

  def find_country(name)
    Country.build(country_repository.find_by_name(name).first)
  end

  def find_latest_places_cases(country_id)
    places_cases = {}

    places_repository.find_by_country_id(country_id).each do |place_cases|
      places_cases[place_cases['name']] = PlaceCases.build(place_cases)
    end

    places_cases
  end

  def build_places_cases(latest_places_cases, scraped_places_cases)
    places_cases = []

    scraped_places_cases.each do |place, cases|
      place_cases = latest_places_cases[place]

      next if place_cases.nil? || place_cases.infected == cases

      places_cases << build_place_cases(place_cases, cases)
    end

    places_cases
  end

  def build_place_cases(place_cases, infected)
    PlaceCases.new(
      name: place_cases.name,
      place_id: place_cases.place_id,
      latitude: place_cases.latitude,
      longitude: place_cases.longitude,
      infected: infected,
      cured: place_cases.cured,
      fatal: place_cases.fatal,
      timestamp: Time.now.to_s
    )
  end
end
