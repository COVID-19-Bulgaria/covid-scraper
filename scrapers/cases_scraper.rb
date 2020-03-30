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

  def scrape
    Cases.new(
      country: @country,
      infected: infected,
      cured: cured,
      fatal: fatal,
      timestamp: Time.now.to_s
    )
  end

  private

  def fetch_page
    URI.open(uri)
  end
end
