# frozen_string_literal: true

require 'sidekiq-cron'
require_relative './workers/scrape_cases_worker'

jobs = [
  {
    name: 'BulgariaCasesScraper',
    cron: '0,30 8,12,17,22 * * * Europe/Sofia',
    class: 'ScrapeCasesWorker',
    args: ['BulgariaCasesScraper']
  }
].freeze

Sidekiq::Cron::Job.load_from_array(jobs)
