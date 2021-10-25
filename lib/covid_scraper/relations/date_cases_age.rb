# frozen_string_literal: true

module CovidScraper
  module Relations
    class DateCasesAge < ROM::Relation[:sql]
      schema(:date_cases_age, infer: true)
    end
  end
end
