# frozen_string_literal: true

module CovidScraper
  module Contracts
    module PlacesCases
      class CreatePlacesCase < Dry::Validation::Contract
        params do
          required(:place_id).filled(:integer)
          required(:infected).filled(:integer)
          required(:cured).filled(:integer)
          required(:fatal).filled(:integer)
          optional(:sources).value(:string)
          required(:timestamp).filled(:time)
        end
      end
    end
  end
end
