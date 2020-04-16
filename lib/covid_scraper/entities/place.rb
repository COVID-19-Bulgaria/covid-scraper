# frozen_string_literal: true

module CovidScraper
  class Place < ROM::Struct
    attribute :id, Types::Coercible::Integer
    attribute :country_id, Types::Coercible::Integer
    attribute :name, Types::Coercible::String
    attribute :longitude, Types::Coercible::Float
    attribute :latitude, Types::Coercible::Float
  end
end
