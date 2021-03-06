# frozen_string_literal: true

module CovidScraper
  module Entities
    class DatePlacesCase < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :place, Types::Coercible::String
      attribute :infected, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
