# frozen_string_literal: true

class Country
  attr_reader :id, :name, :latitude, :longitude, :zoom

  def initialize(id:, name:, latitude:, longitude:, zoom:)
    @id = id.to_i
    @name = name
    @latitude = latitude.to_f
    @longitude = longitude.to_f
    @zoom = zoom.to_i
  end

  def self.build(data)
    new(
      id: data['id'],
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      zoom: data['zoom']
    )
  end

  def to_h
    {
      id: @id,
      name: @name,
      latitude: @latitude,
      longitude: @longitude,
      zoom: @zoom
    }
  end

  def to_json(*_args)
    to_h.to_json
  end
end
