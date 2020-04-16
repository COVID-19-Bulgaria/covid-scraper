# frozen_string_literal: true

module CovidScraper
  module Contracts
    module Cases
      class CreateCase < Dry::Validation::Contract
        params do
          required(:infected).filled(:integer)
          required(:cured).filled(:integer)
          required(:fatal).filled(:integer)
          optional(:men).value(:integer)
          optional(:women).value(:integer)
          optional(:hospitalized).value(:integer)
          optional(:intensive_care).value(:integer)
          optional(:medical_staff).value(:integer)
          required(:timestamp).filled(:time)
          required(:country_id).filled(:integer)
        end
      end
    end
  end
end
