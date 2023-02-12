# frozen_string_literal: true

require 'csv'

module WordMem
  # Class that models the project's Expression Database
  class DatabaseElement
    attr_reader :expression, :reviews_b2t, :reviews_t2b, :score_b2t, :score_t2b

    # @param [String] expression The word or sentence to be saved in the
    #   expression database
    def initialize(expression)
      @expression = expression
      @reviews_b2t = 0
      @reviews_t2b = 0
      @score_b2t = 0
      @score_t2b = 0
    end

    # @return [Array] The database row for +@expression+
    # @example: ['word', 0, 0, 0, 0]
    def to_array
      [expression, reviews_b2t, reviews_t2b, score_b2t, score_t2b]
    end
  end
end
