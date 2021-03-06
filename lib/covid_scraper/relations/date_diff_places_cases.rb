# frozen_string_literal: true

module CovidScraper
  module Relations
    class DateDiffPlacesCases < ROM::Relation[:sql]
      schema(:date_diff_places_cases, infer: true)
    end
  end
end
