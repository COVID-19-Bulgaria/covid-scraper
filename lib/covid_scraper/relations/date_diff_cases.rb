# frozen_string_literal: true

module CovidScraper
  module Relations
    class DateDiffCases < ROM::Relation[:sql]
      schema(:date_diff_cases, infer: true)
    end
  end
end
