# frozen_string_literal: true

module CovidScraper
  module Relations
    class RollingBiweeklyPlacesCases < ROM::Relation[:sql]
      schema(:rolling_biweekly_places_cases, infer: true)
    end
  end
end
