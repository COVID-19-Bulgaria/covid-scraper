# frozen_string_literal: true

module CovidScraper
  module Entities
    class Case < ROM::Struct
      attribute? :id, Types::Coercible::Integer
      attribute :country_id, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
      attribute :cured, Types::Coercible::Integer
      attribute :fatal, Types::Coercible::Integer
      attribute? :men, Types::Coercible::Integer
      attribute? :women, Types::Coercible::Integer
      attribute? :hospitalized, Types::Coercible::Integer
      attribute? :intensive_care, Types::Coercible::Integer
      attribute? :medical_staff, Types::Coercible::Integer
      attribute? :pcr_tests, Types::Coercible::Integer
      attribute? :sources, Types::Coercible::String
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
