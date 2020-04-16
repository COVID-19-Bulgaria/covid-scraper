# frozen_string_literal: true

module CovidScraper
  module Relations
    class Cases < ROM::Relation[:sql]
      schema(:cases, infer: true)
    end
  end
end
