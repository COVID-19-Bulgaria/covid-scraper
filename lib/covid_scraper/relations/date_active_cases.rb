# frozen_string_literal: true

module CovidScraper
  module Relations
    class DateActiveCases < ROM::Relation[:sql]
      schema(:date_active_cases, infer: true)
    end
  end
end
