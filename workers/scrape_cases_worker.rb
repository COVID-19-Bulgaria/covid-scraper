# frozen_string_literal: true

require_relative '../db/database'
require_relative '../repositories/cases_repository'
require_relative '../scrapers/bulgaria_cases_scraper'
require_relative './export_json_worker'

class ScrapeCasesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 2, backtrace: true

  def perform(class_name)
    scraper_class = Object.const_get(class_name)
    scraper = scraper_class.new

    database_client = Database.client
    cases_repository = CasesRepository.new(database_client)

    latest_cases = Cases.build(cases_repository.latest(scraper.country).first)
    scraped_cases = scraper.scrape

    return if latest_cases == scraped_cases

    cases_repository.insert(scraped_cases)
    ExportJsonWorker.perform_async(scraper.country)
  ensure
    database_client&.close
  end
end
