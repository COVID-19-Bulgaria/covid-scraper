# frozen_string_literal: true

module CovidScraper
  module Relations
    class CasesAge < ROM::Relation[:sql]
      schema(:cases_age, infer: true)
    end
  end
end
