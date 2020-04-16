# frozen_string_literal: true

module CovidScraper
  module Transactions
    module Cases
      class CreateCase
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        include Import['contracts.cases.create_case']
        include Import['repositories.cases_repository']

        def call(input)
          values = yield validate(input)
          new_case = yield persist(values)

          Success(new_case)
        end

        def validate(input)
          create_case.call(input).to_monad
        end

        def persist(result)
          Success(cases_repository.create(result.values))
        end
      end
    end
  end
end
