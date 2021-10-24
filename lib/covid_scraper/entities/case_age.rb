# frozen_string_literal: true

module CovidScraper
  module Entities
    class CaseAge < ROM::Struct
      attribute? :id, Types::Coercible::Integer.optional
      attribute :country_id, Types::Coercible::Integer
      attribute? :'0_1', Types::Coercible::Integer.optional
      attribute? :'1_5', Types::Coercible::Integer.optional
      attribute? :'6_9', Types::Coercible::Integer.optional
      attribute? :'10_14', Types::Coercible::Integer.optional
      attribute? :'15_19', Types::Coercible::Integer.optional
      attribute? :'0_19', Types::Coercible::Integer.optional
      attribute? :'20_29', Types::Coercible::Integer.optional
      attribute? :'30_39', Types::Coercible::Integer.optional
      attribute? :'40_49', Types::Coercible::Integer.optional
      attribute? :'50_59', Types::Coercible::Integer.optional
      attribute? :'60_69', Types::Coercible::Integer.optional
      attribute? :'70_79', Types::Coercible::Integer.optional
      attribute? :'80_89', Types::Coercible::Integer.optional
      attribute? :'90', Types::Coercible::Integer.optional
      attribute :timestamp, Types::Nominal::Time
    end
  end
end
