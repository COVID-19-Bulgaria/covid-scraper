# frozen_string_literal: true

module CovidScraper
  module Relations
    class DateCases < ROM::Relation[:sql]
      schema(:date_cases, infer: true)
    end
  end
end
