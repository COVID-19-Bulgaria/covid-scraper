# frozen_string_literal: true

module CovidScraper
  module Mappers
    class LatestPlacesCasesMapper < ROM::Transformer
      relation :latest_places_cases
      register_as :latest_places_cases_mapper

      map_array t(
        lambda do |v|
          {
            v.name => {
              coordinates: [v.latitude, v.longitude],
              infected: v.infected,
              newly_infected: v.newly_infected,
              infected_14d_100k: v.infected_14d_100k,
              timestamp: v.timestamp
            }
          }
        end
      )
    end
  end
end
