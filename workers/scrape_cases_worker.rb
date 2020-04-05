# frozen_string_literal: true

require_relative '../helpers/database_helpers'
require_relative '../repositories/cases_repository'
require_relative '../repositories/country_repository'
require_relative '../scrapers/bulgaria_cases_scraper'
require_relative '../scrapers/bulgaria_vma_cases_scraper'
require_relative '../models/country'
require_relative './export_cases_json_worker'

class ScrapeCasesWorker
  include Sidekiq::Worker
  include DatabaseHelpers

  sidekiq_options queue: :scraping, retry: 2, backtrace: true

  def perform(class_name)
    scraper_class = Object.const_get(class_name)
    scraper = scraper_class.new

    country = find_country(scraper.country)
    latest_cases = find_latest_cases(country.id)
    scraped_cases = scraper.scrape(country.id)

    return if scraper.cases_match(latest_cases, scraped_cases)

    cases_repository.insert(scraped_cases)
    ExportCasesJsonWorker.perform_async(scraper.country)
  ensure
    database_client&.close
  end

  private

  def country_repository
    @country_repository ||= CountryRepository.new(database_client)
  end

  def cases_repository
    @cases_repository ||= CasesRepository.new(database_client)
  end

  def find_country(name)
    Country.build(country_repository.find_by_name(name).first)
  end

  def find_latest_cases(country_id)
    Cases.build(cases_repository.latest(country_id).first)
  end
end
