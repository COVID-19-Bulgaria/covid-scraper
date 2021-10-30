# frozen_string_literal: true

module CovidScraper
  module Contracts
    module PlacesCases
      class CreatePlacesCase < Dry::Validation::Contract
        params do
          required(:place_id).filled(:integer)
          required(:infected).filled(:integer)
          optional(:doses).maybe(:integer)
          optional(:fully_vaccinated).maybe(:integer)
          optional(:booster).maybe(:integer)
          optional(:sources).maybe(:string)
          required(:timestamp).filled(:time)
        end
      end
    end
  end
end
