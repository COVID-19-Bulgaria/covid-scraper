# frozen_string_literal: true

module CovidScraper
  module Entities
    class DatePositiveTest < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :pcr_tests, Types::Coercible::Integer
      attribute :antigen_tests, Types::Coercible::Integer
      attribute :positive_percentage, Types::Coercible::Decimal
      attribute :positive_pcr_tests, Types::Coercible::Integer
      attribute :pcr_positive_percentage, Types::Coercible::Decimal
      attribute :positive_antigen_tests, Types::Coercible::Integer
      attribute :antigen_positive_percentage, Types::Coercible::Decimal
      attribute :date, Types::Nominal::Date
    end
  end
end
