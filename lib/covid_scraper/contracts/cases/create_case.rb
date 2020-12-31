# frozen_string_literal: true

module CovidScraper
  module Contracts
    module Cases
      class CreateCase < Dry::Validation::Contract
        params do
          required(:infected).filled(:integer)
          required(:cured).filled(:integer)
          required(:fatal).filled(:integer)
          optional(:men).maybe(:integer)
          optional(:women).maybe(:integer)
          optional(:hospitalized).maybe(:integer)
          optional(:intensive_care).maybe(:integer)
          optional(:medical_staff).maybe(:integer)
          optional(:pcr_tests).maybe(:integer)
          optional(:antigen_tests).maybe(:integer)
          optional(:vaccinated).maybe(:integer)
          required(:timestamp).filled(:time)
          required(:country_id).filled(:integer)
        end
      end
    end
  end
end
