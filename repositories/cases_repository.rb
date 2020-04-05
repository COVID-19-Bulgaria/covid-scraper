# frozen_string_literal: true

require_relative './base_repository'

class CasesRepository < BaseRepository
  def initialize(database_client)
    super
    prepare_insert_statement
    prepare_find_latest_statement
    prepare_find_date_cases_by_country_statement
    prepare_find_date_diff_cases_by_country_statement
  end

  def insert(cases)
    database_client.exec_prepared(
      'insert_cases',
      [
        cases.country_id, cases.infected, cases.cured, cases.fatal, cases.men,
        cases.women, cases.hospitalized, cases.intensive_care,
        cases.medical_staff, cases.timestamp
      ]
    )
  end

  def latest(country_id)
    database_client.exec_prepared('find_latest_cases', [country_id])
  end

  def date_cases(country)
    database_client.exec_prepared('find_date_cases_by_country', [country])
  end

  def date_diff_cases(country)
    database_client.exec_prepared('find_date_diff_cases_by_country', [country])
  end

  private

  def prepare_insert_statement
    database_client.prepare(
      'insert_cases',
      '
        insert into covid19.cases
        (country_id, infected, cured, fatal, men, women, hospitalized,
         intensive_care, medical_staff, timestamp)
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      '
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end

  def prepare_find_latest_statement
    database_client.prepare(
      'find_latest_cases',
      '
        select * from covid19.cases c
        where c.country_id = $1
        order by c.timestamp desc
        limit 1
      '
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end

  def prepare_find_date_cases_by_country_statement
    database_client.prepare(
      'find_date_cases_by_country',
      '
        select * from covid19.date_cases dc
        where dc.country = $1
      '
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end

  def prepare_find_date_diff_cases_by_country_statement
    database_client.prepare(
      'find_date_diff_cases_by_country',
      '
        select * from covid19.date_diff_cases dc
        where dc.country = $1
      '
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end
end
