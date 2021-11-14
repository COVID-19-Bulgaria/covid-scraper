# frozen_string_literal: true

module CovidScraper
  module Entities
    class CasesAgeEntity < ROM::Struct
      attribute? :id, Types::Coercible::Integer.optional
      attribute :country_id, Types::Coercible::Integer
      attribute? :group_0_1, Types::Coercible::Integer.optional
      attribute? :group_1_5, Types::Coercible::Integer.optional
      attribute? :group_6_9, Types::Coercible::Integer.optional
      attribute? :group_10_14, Types::Coercible::Integer.optional
      attribute? :group_15_19, Types::Coercible::Integer.optional
      attribute? :group_0_19, Types::Coercible::Integer.optional
      attribute? :group_20_29, Types::Coercible::Integer.optional
      attribute? :group_30_39, Types::Coercible::Integer.optional
      attribute? :group_40_49, Types::Coercible::Integer.optional
      attribute? :group_50_59, Types::Coercible::Integer.optional
      attribute? :group_60_69, Types::Coercible::Integer.optional
      attribute? :group_70_79, Types::Coercible::Integer.optional
      attribute? :group_80_89, Types::Coercible::Integer.optional
      attribute? :group_90, Types::Coercible::Integer.optional
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
