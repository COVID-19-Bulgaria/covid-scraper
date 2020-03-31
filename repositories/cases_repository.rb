# frozen_string_literal: true

require_relative './base_repository'

class CasesRepository < BaseRepository
  def insert(cases)
    begin
      database_client.prepare(
        'insert_cases',
        '
          insert into covid19.cases
          (country, infected, cured, fatal, timestamp)
          values ($1, $2, $3, $4, $5)
        '
      )
    rescue PG::DuplicatePstatement => e
      puts e.message
    end

    database_client.exec_prepared('insert_cases', [
                                    cases.country,
                                    cases.infected,
                                    cases.cured,
                                    cases.fatal,
                                    cases.timestamp
                                  ])
  end

  def latest(country)
    begin
      database_client.prepare(
        'find_latest',
        '
          select * from covid19.cases c
          where c.country = $1
          order by c.timestamp desc
          limit 1
        '
      )
    rescue PG::DuplicatePstatement => e
      puts e.message
    end

    database_client.exec_prepared('find_latest', [country])
  end

  def date_cases(country)
    begin
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

    database_client.exec_prepared('find_date_cases_by_country', [country])
  end

  def date_diff_cases(country)
    begin
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

    database_client.exec_prepared('find_date_diff_cases_by_country', [country])
  end
end
