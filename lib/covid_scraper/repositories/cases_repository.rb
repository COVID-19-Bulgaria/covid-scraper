# frozen_string_literal: true

module CovidScraper
  module Repositories
    class CasesRepository < ROM::Repository[:cases]
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
        cases.to_a
      end

      def latest(country_id)
        cases.where(country_id: country_id)
             .order { timestamp.desc }
             .limit(1)
             .first
      end
    end
  end
end
