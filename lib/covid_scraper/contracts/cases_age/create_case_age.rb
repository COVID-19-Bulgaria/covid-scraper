# frozen_string_literal: true

module CovidScraper
  module Contracts
    module CasesAge
      class CreateCaseAge < Dry::Validation::Contract
        params do
          required(:country_id).filled(:integer)
          optional(:group_0_1).maybe(:integer)
          optional(:group_1_5).maybe(:integer)
          optional(:group_6_9).maybe(:integer)
          optional(:group_10_14).maybe(:integer)
          optional(:group_15_19).maybe(:integer)
          optional(:group_0_19).maybe(:integer)
          optional(:group_20_29).maybe(:integer)
          optional(:group_30_39).maybe(:integer)
          optional(:group_40_49).maybe(:integer)
          optional(:group_50_59).maybe(:integer)
          optional(:group_60_69).maybe(:integer)
          optional(:group_70_79).maybe(:integer)
          optional(:group_80_89).maybe(:integer)
          optional(:group_90).maybe(:integer)
          required(:timestamp).filled(:time)
        end
      end
    end
  end
end
