# frozen_string_literal: true

module CovidScraper
  module Relations
    class Countries < ROM::Relation[:sql]
      schema(:countries, infer: true)
    end
  end
end
