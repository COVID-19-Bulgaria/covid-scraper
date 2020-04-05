# frozen_string_literal: true

require_relative './base_repository'

class CountryRepository < BaseRepository
  def initialize(database_client)
    super
    prepare_find_country_by_id_statement
    prepare_find_country_by_name_statement
  end

  def find_by_id(id)
    database_client.exec_prepared('find_country_by_id', [id])
  end

  def find_by_name(name)
    database_client.exec_prepared('find_country_by_name', [name])
  end

  private

  def prepare_find_country_by_id_statement
    database_client.prepare(
      'find_country_by_id',
      'select * from covid19.countries c where c.id = $1'
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end

  def prepare_find_country_by_name_statement
    database_client.prepare(
      'find_country_by_name',
      'select * from covid19.countries c where c.name = $1'
    )
  rescue PG::DuplicatePstatement => e
    puts e.message
  end
end
