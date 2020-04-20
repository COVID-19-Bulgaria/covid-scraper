# frozen_string_literal: true

module CovidScraper
  module Entities
    class LatestPlacesCase < ROM::Struct
      attribute :place_id, Types::Coercible::Integer
      attribute :name, Types::Coercible::String
      attribute :country_id, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
      attribute :cured, Types::Coercible::Integer
      attribute :fatal, Types::Coercible::Integer
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
