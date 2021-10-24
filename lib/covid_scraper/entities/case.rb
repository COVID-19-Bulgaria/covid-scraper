# frozen_string_literal: true

module CovidScraper
  module Entities
    class Case < ROM::Struct
      attribute? :id, Types::Coercible::Integer.optional
      attribute :country_id, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
      attribute :cured, Types::Coercible::Integer
      attribute :fatal, Types::Coercible::Integer
      attribute? :men, Types::Coercible::Integer.optional
      attribute? :women, Types::Coercible::Integer.optional
      attribute? :hospitalized, Types::Coercible::Integer.optional
      attribute? :intensive_care, Types::Coercible::Integer.optional
      attribute? :medical_staff, Types::Coercible::Integer.optional
      attribute? :pcr_tests, Types::Coercible::Integer.optional
      attribute? :positive_pcr_tests, Types::Coercible::Integer.optional
      attribute? :antigen_tests, Types::Coercible::Integer.optional
      attribute? :positive_antigen_tests, Types::Coercible::Integer.optional
      attribute? :vaccinated, Types::Coercible::Integer.optional
      attribute? :sources, Types::Coercible::String.optional
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
