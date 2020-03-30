# frozen_string_literal: true

require 'sidekiq-cron'
require_relative './workers/scrape_cases_worker'

jobs = [
  {
    name: 'BulgariaCasesScraper',
    cron: '*/15 * * * * Europe/Sofia',
    class: 'ScrapeCasesWorker',
    args: ['BulgariaCasesScraper']
  }
].freeze

Sidekiq::Cron::Job.load_from_array(jobs)
