# frozen_string_literal: true

require_relative '../db/database'
require_relative '../helpers/file_helpers'
require_relative '../helpers/database_helpers'
require_relative '../repositories/cases_repository'
require_relative '../repositories/places_repository'
require_relative '../models/date_cases'
require_relative './publish_datasets_worker'

class ExportCasesJsonWorker
  include FileHelpers
  include DatabaseHelpers

  include Sidekiq::Worker
  sidekiq_options retry: 2, backtrace: true

  TOTALS_DATASET_FILENAME = 'TotalsDataset.json'
  DATE_CASES_FILENAME = 'DateCasesDataset.json'
  DATE_DIFF_CASES_FILENAME = 'DateDiffCasesDataset.json'

  def perform(country)
    write_file(
      filename: build_database_file_path(country, TOTALS_DATASET_FILENAME),
      data: latest_cases(country)
    )

    write_file(
      filename: build_database_file_path(country, DATE_CASES_FILENAME),
      data: date_cases(country)
    )

    write_file(
      filename: build_database_file_path(country, DATE_DIFF_CASES_FILENAME),
      data: date_diff_cases(country)
    )

    PublishDatasetsWorker.perform_async
  ensure
    database_client&.close
  end

  private

  def cases_repository
    @cases_repository ||= CasesRepository.new(database_client)
  end

  def latest_cases(country)
    Cases.build(cases_repository.latest(country).first).to_json
  end

  def date_cases(country)
    build_categorized_cases_json(cases_repository.date_cases(country))
  end

  def date_diff_cases(country)
    build_categorized_cases_json(cases_repository.date_diff_cases(country))
  end

  def build_categorized_cases_json(cases)
    document = { infected: {}, cured: {}, fatal: {} }

    cases.each do |date_cases|
      document[:infected].merge!(DateCases.new(
        date: date_cases['date'],
        cases: date_cases['infected']
      ).to_h)

      document[:cured].merge!(DateCases.new(
        date: date_cases['date'],
        cases: date_cases['cured']
      ).to_h)

      document[:fatal].merge!(DateCases.new(
        date: date_cases['date'],
        cases: date_cases['fatal']
      ).to_h)
    end

    document.to_json
  end
end
