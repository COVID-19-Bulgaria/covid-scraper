# frozen_string_literal: true

module CovidScraper
  module Entities
    class LatestPlacesCasesEntity < ROM::Struct
      attribute :name, Types::Coercible::String
      attribute :longitude, Types::Coercible::Float
      attribute :latitude, Types::Coercible::Float
      attribute :infected, Types::Coercible::Integer
      attribute :newly_infected, Types::Coercible::Integer
      attribute :infected_14d_100k, Types::Coercible::Integer
      attribute :doses, Types::Coercible::Integer
      attribute :new_doses, Types::Coercible::Integer
      attribute :fully_vaccinated, Types::Coercible::Integer
      attribute :new_fully_vaccinated, Types::Coercible::Integer
      attribute :booster, Types::Coercible::Integer
      attribute :new_booster, Types::Coercible::Integer
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
