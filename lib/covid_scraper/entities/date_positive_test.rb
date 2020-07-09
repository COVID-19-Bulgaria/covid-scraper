# frozen_string_literal: true

module CovidScraper
  module Entities
    class DatePositiveTest < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :positive_percentage, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
