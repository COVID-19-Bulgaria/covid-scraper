# frozen_string_literal: true

require_relative './config/application'

CovidScraper::Application.finalize!

jobs = [
  {
    name: 'BulgariaCasesScraper',
    cron: '*/15 8,9,10,11,17,18,19,20,0 * * * Europe/Sofia',
    class: 'CovidScraper::Workers::ScrapeCasesWorker',
    args: ['CovidScraper::Scrapers::BulgariaPortalHomepageCasesScraper']
  },
  {
    name: 'BulgariaPlacesCasesScraper',
    cron: '*/15 8,9,10,11,17,18,19,20,0 * * * Europe/Sofia',
    class: 'CovidScraper::Workers::ScrapePlacesCasesWorker',
    args: ['CovidScraper::Scrapers::BulgariaPortalHomepageCasesScraper']
  },
  {
    name: 'BulgariaVMACasesScraper',
    cron: '*/15 8,9,10,11,17,18,19,20 * * * Europe/Sofia',
    class: 'CovidScraper::Workers::ScrapeCasesWorker',
    args: ['CovidScraper::Scrapers::BulgariaVMACasesScraper'],
    status: 'disabled'
  },
  {
    name: 'ExportCases',
    cron: '0 18 * * * Europe/Sofia',
    class: 'CovidScraper::Workers::ExportCasesDatasetsWorker',
    args: ['Bulgaria'],
    status: 'disabled'
  },
  {
    name: 'ExportPlacesCases',
    cron: '0 18 * * * Europe/Sofia',
    class: 'CovidScraper::Workers::ExportPlacesDatasetsWorker',
    args: ['Bulgaria'],
    status: 'disabled'
  }
].freeze

Sidekiq::Cron::Job.load_from_array(jobs)
