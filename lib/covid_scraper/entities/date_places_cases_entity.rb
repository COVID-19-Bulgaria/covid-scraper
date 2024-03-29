# frozen_string_literal: true

module CovidScraper
  module Entities
    class DatePlacesCasesEntity < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :place, Types::Coercible::String
      attribute :infected, Types::Coercible::Integer
      attribute :doses, Types::Coercible::Integer
      attribute :fully_vaccinated, Types::Coercible::Integer
      attribute :booster, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
