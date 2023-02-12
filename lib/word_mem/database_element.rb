# frozen_string_literal: true

require 'csv'

module WordMem
  # Class that models the project's Word Database
  class DatabaseElement
    attr_reader :expression, :reviews_b2t, :reviews_t2b, :score_b2t, :score_t2b

    def initialize(expression)
      @expression = expression
      @reviews_b2t = 0
      @reviews_t2b = 0
      @score_b2t = 0
      @score_t2b = 0
    end

    def to_row
      [expression, reviews_b2t, reviews_t2b, score_b2t, score_t2b]
    end
  end
end
