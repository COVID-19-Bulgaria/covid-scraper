# frozen_string_literal: true

module CovidScraper
  module Relations
    class WeekPlacesCases < ROM::Relation[:sql]
      schema(:week_places_cases, infer: true)
    end
  end
end
