# frozen_string_literal: true

class ArticleSegmentationError < StandardError
  MESSAGE = 'Could not find %s field. Probably the article format changed.'

  attr_reader :field

  def initialize(field:, message: MESSAGE)
    @field = field
    super(message % field)
  end
end
