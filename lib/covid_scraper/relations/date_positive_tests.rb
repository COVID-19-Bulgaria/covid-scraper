# frozen_string_literal: true

module CovidScraper
  module Relations
    class DatePositiveTests < ROM::Relation[:sql]
      schema(:date_positive_tests, infer: true)
    end
  end
end
