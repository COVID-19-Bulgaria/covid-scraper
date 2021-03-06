# frozen_string_literal: true

module CovidScraper
  module Relations
    class WeekCases < ROM::Relation[:sql]
      schema(:week_cases, infer: true)
    end
  end
end
