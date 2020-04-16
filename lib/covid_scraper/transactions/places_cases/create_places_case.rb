# frozen_string_literal: true

module CovidScraper
  module Transactions
    module PlacesCases
      class CreatePlacesCase
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        include Import['contracts.places_cases.create_places_case']
        include Import['repositories.places_cases_repository']

        def call(input)
          values = yield validate(input)
          places_case = yield persist(values)

          Success(places_case)
        end

        def validate(input)
          create_places_case.call(input).to_monad
        end

        def persist(result)
          Success(places_cases_repository.create(result.values))
        end
      end
    end
  end
end
