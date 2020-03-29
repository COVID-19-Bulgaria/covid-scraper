# frozen_string_literal: true

class Cases
  attr_reader :country, :infected, :cured, :fatal, :timestamp

  def initialize(country:, infected:, cured:, fatal:, timestamp:)
    @country = country
    @infected = infected.to_i
    @cured = cured.to_i
    @fatal = fatal.to_i
    @timestamp = timestamp
  end

  def to_h
    {
      country: @country,
      infected: @infected,
      cured: @cured,
      fatal: @fatal,
      timestamp: @timestamp
    }
  end

  def to_json(*_args)
    to_h.to_json
  end
end
