# frozen_string_literal: true

module CovidScraper
  module Entities
    class PlacesCase < ROM::Struct
      attribute? :id, Types::Coercible::Integer
      attribute :place_id, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
      attribute :doses, Types::Coercible::Integer
      attribute :fully_vaccinated, Types::Coercible::Integer
      attribute :booster, Types::Coercible::Integer
      attribute? :sources, Types::Coercible::String
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
