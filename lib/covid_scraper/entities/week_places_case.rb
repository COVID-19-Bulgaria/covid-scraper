# frozen_string_literal: true

module CovidScraper
  module Entities
    class WeekPlacesCase < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :place, Types::Coercible::String
      attribute :year, Types::Coercible::Integer
      attribute :week, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
      attribute :infected_avg, Types::Coercible::Integer
      attribute :infected_100k, Types::Coercible::Integer
      attribute :infected_avg_100k, Types::Coercible::Integer
    end
  end
end
