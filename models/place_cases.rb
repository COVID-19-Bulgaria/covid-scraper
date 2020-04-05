# frozen_string_literal: true

class PlaceCases
  attr_reader :name, :place_id, :latitude, :longitude, :infected, :cured,
              :fatal, :timestamp

  def initialize(name:, place_id:, latitude:, longitude:, infected:, cured:,
                 fatal:, timestamp:)
    @name = name
    @place_id = place_id.to_i
    @latitude = latitude.to_f
    @longitude = longitude.to_f
    @infected = infected.to_i
    @cured = cured.to_i
    @fatal = fatal.to_i
    @timestamp = timestamp
  end

  def self.build(data)
    new(
      name: data['name'],
      place_id: data['place_id'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      infected: data['infected'],
      cured: data['cured'],
      fatal: data['fatal'],
      timestamp: data['timestamp']
    )
  end

  def to_h
    {
      @name => {
        coordinates: [@latitude, @longitude],
        infected: @infected,
        cured: @cured,
        fatal: @fatal,
        timestamp: @timestamp
      }
    }
  end
end
