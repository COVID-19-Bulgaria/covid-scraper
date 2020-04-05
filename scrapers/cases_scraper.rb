# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require_relative '../models/cases'

class CasesScraper
  attr_reader :country
  attr_reader :uri

  def initialize(country:, uri:)
    @country = country
    @uri = uri
  end

  def parse
    @parse ||= Nokogiri::HTML(fetch_page)
  end

  def infected
    raise 'Override with actual implementation.'
  end

  def cured
    raise 'Override with actual implementation.'
  end

  def fatal
    raise 'Override with actual implementation.'
  end

  def men
    raise 'Override with actual implementation.'
  end

  def women
    raise 'Override with actual implementation.'
  end

  def hospitalized
    raise 'Override with actual implementation.'
  end

  def intensive_care
    raise 'Override with actual implementation.'
  end

  def medical_staff
    raise 'Override with actual implementation.'
  end

  def regions_cases
    raise 'Override with actual implementation.'
  end

  def scrape(country_id)
    Cases.new(
      country_id: country_id,
      infected: infected,
      cured: cured,
      fatal: fatal,
      men: men,
      women: women,
      hospitalized: hospitalized,
      intensive_care: intensive_care,
      medical_staff: medical_staff,
      timestamp: Time.now.to_s
    )
  end

  def cases_match(first, second)
    first == second
  end

  private

  def fetch_page
    URI.open(uri)
  end
end
