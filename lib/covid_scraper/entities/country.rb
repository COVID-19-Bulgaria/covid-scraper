# frozen_string_literal: true

module CovidScraper
  module Entities
    class Country < ROM::Struct
      attribute :id, Types::Coercible::Integer
      attribute :name, Types::Coercible::String
      attribute :longitude, Types::Coercible::Float
      attribute :latitude, Types::Coercible::Float
      attribute :zoom, Types::Coercible::Integer
    end
  end
end
