# frozen_string_literal: true

module CovidScraper
  module Transactions
    module CasesAge
      class CreateCaseAge
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        include Import['contracts.cases_age.create_case_age']
        include Import['repositories.cases_age_repository']

        def call(input)
          values = yield validate(input)
          new_case_age = yield persist(values)

          Success(new_case_age)
        end

        def validate(input)
          create_case_age.call(input).to_monad
        end

        def persist(result)
          Success(cases_age_repository.create(result.values))
        end
      end
    end
  end
end
