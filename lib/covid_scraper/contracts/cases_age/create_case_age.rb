# frozen_string_literal: true

module CovidScraper
  module Contracts
    module CasesAge
      class CreateCaseAge < Dry::Validation::Contract
        params do
          required(:country_id).filled(:integer)
          optional(:'0_1').maybe(:integer)
          optional(:'1_5').maybe(:integer)
          optional(:'6_9').maybe(:integer)
          optional(:'10_14').maybe(:integer)
          optional(:'15_19').maybe(:integer)
          optional(:'0_19').maybe(:integer)
          optional(:'20_29').maybe(:integer)
          optional(:'30_39').maybe(:integer)
          optional(:'40_49').maybe(:integer)
          optional(:'50_59').maybe(:integer)
          optional(:'60_69').maybe(:integer)
          optional(:'70_79').maybe(:integer)
          optional(:'80_89').maybe(:integer)
          optional(:'90').maybe(:integer)
          required(:timestamp).filled(:time)
        end
      end
    end
  end
end
