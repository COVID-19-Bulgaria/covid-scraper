# frozen_string_literal: true

module CovidScraper
  module Entities
    class WeekPlacesCase < ROM::Struct
      attribute :place, Types::Coercible::String
      attribute :year, Types::Coercible::Integer
      attribute :week, Types::Coercible::Integer
      attribute :infected, Types::Coercible::Integer
    end
  end
end
