# frozen_string_literal: true

module CovidScraper
  module Relations
    class PlacesCases < ROM::Relation[:sql]
      schema(:places_cases, infer: true)
    end
  end
end
