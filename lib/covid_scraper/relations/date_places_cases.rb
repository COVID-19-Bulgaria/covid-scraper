# frozen_string_literal: true

module CovidScraper
  module Relations
    class DatePlacesCases < ROM::Relation[:sql]
      schema(:date_places_cases, infer: true)
    end
  end
end
