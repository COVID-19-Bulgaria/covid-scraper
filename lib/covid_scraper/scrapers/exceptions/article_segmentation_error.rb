# frozen_string_literal: true

module CovidScraper
  module Scrapers
    module Exceptions
      class ArticleSegmentationError < StandardError
        MESSAGE = 'Could not find %s field. Probably the article format changed.'

        attr_reader :field

        def initialize(field:, message: MESSAGE)
          @field = field
          super(message % field)
        end
      end
    end
  end
end
