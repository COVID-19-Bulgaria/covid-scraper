# frozen_string_literal: true

module CovidScraper
  module Relations
    class LatestPlacesCases < ROM::Relation[:sql]
      schema(:latest_places_cases, infer: true)
    end
  end
end
