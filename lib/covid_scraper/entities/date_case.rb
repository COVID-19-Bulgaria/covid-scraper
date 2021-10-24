# frozen_string_literal: true

module CovidScraper
  module Entities
    class DateCase < ROM::Struct
      attribute :country, Types::Coercible::String
      attribute :infected, Types::Coercible::Integer
      attribute :cured, Types::Coercible::Integer
      attribute :fatal, Types::Coercible::Integer
      attribute :men, Types::Coercible::Integer
      attribute :women, Types::Coercible::Integer
      attribute :hospitalized, Types::Coercible::Integer
      attribute :intensive_care, Types::Coercible::Integer
      attribute :medical_staff, Types::Coercible::Integer
      attribute :pcr_tests, Types::Coercible::Integer
      attribute :positive_pcr_tests, Types::Coercible::Integer
      attribute :antigen_tests, Types::Coercible::Integer
      attribute :positive_antigen_tests, Types::Coercible::Integer
      attribute :vaccinated, Types::Coercible::Integer
      attribute :date, Types::Nominal::Date
    end
  end
end
