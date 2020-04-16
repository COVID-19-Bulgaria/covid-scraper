# frozen_string_literal: true

module CovidScraper
  module Relations
    class Places < ROM::Relation[:sql]
      schema(:places, infer: true)
    end
  end
end
