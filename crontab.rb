# frozen_string_literal: true

require 'sidekiq-cron'
require_relative './workers/scrape_cases_worker'
require_relative './workers/scrape_places_cases_worker'
require_relative './workers/export_places_json_worker'

jobs = [
  {
    name: 'BulgariaCasesScraper',
    cron: '*/15 * * * * Europe/Sofia',
    class: 'ScrapeCasesWorker',
    args: ['BulgariaCasesScraper']
  },
  {
    name: 'BulgariaVMACasesScraper',
    cron: '30 8,17 * * * Europe/Sofia',
    class: 'ScrapeCasesWorker',
    args: ['BulgariaVMACasesScraper'],
  },
  {
    name: 'BulgariaPlacesCasesScraper',
    cron: '30 8,17 * * * Europe/Sofia',
    class: 'ScrapePlacesCasesWorker',
    args: ['BulgariaVMACasesScraper'],
  },
  {
    name: 'ExportPlacesCases',
    cron: '0 18 * * * Europe/Sofia',
    class: 'ExportPlacesJsonWorker',
    args: [],
    status: 'disabled'
  }
].freeze

Sidekiq::Cron::Job.load_from_array(jobs)
