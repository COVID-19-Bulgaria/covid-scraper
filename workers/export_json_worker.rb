# frozen_string_literal: true

require_relative '../db/database'
require_relative '../repositories/cases_repository'
require_relative '../models/date_cases'
require_relative './publish_datasets_worker'

class ExportJsonWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, backtrace: true

  TOTALS_DATASET_FILENAME = 'TotalsDataset.json'
  DATE_CASES_FILENAME = 'DateCasesDataset.json'
  DATE_DIFF_CASES_FILENAME = 'DateDiffCasesDataset.json'

  def perform(country)
    write_file(
      filename: build_totals_file_path(country),
      data: latest_cases(country)
    )

    write_file(
      filename: build_date_cases_file_path(country),
      data: date_cases(country)
    )

    write_file(
      filename: build_date_diff_cases_file_path(country),
      data: date_diff_cases(country)
    )

    PublishDatasetsWorker.perform_async
  ensure
    database_client&.close
  end

  private

  def database_client
    @database_client ||= Database.client
  end

  def cases_repository
    @cases_repository ||= CasesRepository.new(database_client)
  end

  def write_file(filename:, data:)
    IO.write(filename, data, 0, mode: 'w')
  end

  def build_totals_file_path(country)
    File.join(
      ENV['COVID_DATABASE_PATH_CONTAINER'],
      country,
      TOTALS_DATASET_FILENAME
    )
  end

  def build_date_cases_file_path(country)
    File.join(
      ENV['COVID_DATABASE_PATH_CONTAINER'],
      country,
      DATE_CASES_FILENAME
    )
  end

  def build_date_diff_cases_file_path(country)
    File.join(
      ENV['COVID_DATABASE_PATH_CONTAINER'],
      country,
      DATE_DIFF_CASES_FILENAME
    )
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
