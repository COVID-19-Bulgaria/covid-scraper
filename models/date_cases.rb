# frozen_string_literal: true

class DateCases
  def initialize(date:, cases:)
    @date = date
    @cases = cases.to_i
  end

  def to_h
    {
      @date => {
        cases: @cases
      }
    }
  end
end
