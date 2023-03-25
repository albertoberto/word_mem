# frozen_string_literal: true

require_relative 'translator'

module WordMem
  # Class that models the project's Expression Database
  class DatabaseElement
    attr_accessor :expression, :translated_expression, :reviews_b2t, :reviews_t2b, :score_b2t, :score_t2b

    # @param [Hash] args Elements of the database element
    # @option [String] expression The word or sentence to be saved in the
    #   expression database. Mandatory
    # @option [String] translated_expression The translation of +expression+
    # @option [Integer] reviews_b2t The number of reviews from base to target
    #   language
    # @option [Integer] reviews_t2b The number of reviews from target to base
    #   language
    # @option [Float] score_b2t The average self-score on reviews from base to
    #   target language
    # @option [Float] score_t2b The average self-score on reviews from target to
    #   base language
    def initialize(args = {})
      @expression = args[:expression] || raise(ArgumentError, 'Missing expression in WordMem::DatabaseElement')
      @translated_expression = args[:translated_expression] || translator.translate(expression)
      @reviews_b2t = args[:reviews_b2t] || 0
      @reviews_t2b = args[:reviews_t2b] || 0
      @score_b2t = args[:score_b2t] || 0
      @score_t2b = args[:score_t2b] || 0
    end

    # @return [Array] The database row for +@expression+
    # @example: ['wort', 'word', 0, 0, 0, 0]
    def to_array
      [expression, translated_expression, reviews_b2t, reviews_t2b, score_b2t, score_t2b]
    end

    private

    # @return [WordMem::Translator] Class instance
    def translator
      @translator ||= WordMem::Translator.new
    end
  end
end
