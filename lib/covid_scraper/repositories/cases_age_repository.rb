# frozen_string_literal: true

module CovidScraper
  module Repositories
    class CasesAgeRepository < ROM::Repository[:cases_age]
      include Import['container']
      struct_namespace CovidScraper

      commands :create,
               use: :timestamps,
               plugins_options: {
                 timestamps: {
                   timestamps: %i(timestamp)
                 }
               }

      def all
        cases_age.to_a
      end

      def latest(country_id)
        cases_age.where(country_id: country_id)
             .order { timestamp.desc }
             .limit(1)
             .first
      end
    end
  end
end
