# frozen_string_literal: true

module CovidScraper
  module Entities
    class RollingBiweeklyPlacesCasesEntity < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :place, Types::Coercible::String
      attribute :infected, Types::Coercible::Integer
      attribute :infected_avg_100k, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
