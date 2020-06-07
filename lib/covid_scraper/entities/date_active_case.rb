# frozen_string_literal: true

module CovidScraper
  module Entities
    class DateActiveCase < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :active, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
