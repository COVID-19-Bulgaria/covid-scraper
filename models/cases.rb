# frozen_string_literal: true

class Cases
  attr_reader :country_id, :infected, :cured, :fatal, :men, :women, :hospitalized,
              :intensive_care, :medical_staff, :timestamp

  def initialize(country_id:, infected:, cured:, fatal:, men:, women:,
                 hospitalized:, intensive_care:, medical_staff:, timestamp:)
    @country_id = country_id.to_i
    @infected = infected.to_i
    @cured = cured.to_i
    @fatal = fatal.to_i
    @men = men.to_i
    @women = women.to_i
    @hospitalized = hospitalized.to_i
    @intensive_care = intensive_care.to_i
    @medical_staff = medical_staff.to_i
    @timestamp = timestamp
  end

  def self.build(data)
    new(
      country_id: data['country_id'],
      infected: data['infected'],
      cured: data['cured'],
      fatal: data['fatal'],
      men: data['men'],
      women: data['women'],
      hospitalized: data['hospitalized'],
      intensive_care: data['intensive_care'],
      medical_staff: data['medical_staff'],
      timestamp: data['timestamp']
    )
  end

  def to_h
    {
      country_id: @country_id,
      infected: @infected,
      cured: @cured,
      fatal: @fatal,
      men: @men,
      women: @women,
      hospitalized: @hospitalized,
      intensive_care: @intensive_care,
      medical_staff: @medical_staff,
      timestamp: @timestamp
    }
  end

  def to_json(*_args)
    to_h.to_json
  end

  def ==(other)
    country_id == other.country_id &&
      infected == other.infected &&
      cured == other.cured &&
      fatal == other.fatal &&
      men == other.men &&
      women == other.women &&
      hospitalized == other.hospitalized &&
      intensive_care == other.intensive_care &&
      medical_staff == other.medical_staff &&
      Date.parse(timestamp) == Date.parse(other.timestamp)
  end
end
