# frozen_string_literal: true

module CovidScraper
  module Entities
    class LatestPlacesCase < ROM::Struct
      attribute :name, Types::Coercible::String
      attribute :longitude, Types::Coercible::Float
      attribute :latitude, Types::Coercible::Float
      attribute :infected, Types::Coercible::Integer
      attribute :newly_infected, Types::Coercible::Integer
      attribute :infected_14d_100k, Types::Coercible::Integer
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
