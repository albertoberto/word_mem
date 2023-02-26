# frozen_string_literal: true

require_relative 'base'

module WordMem
  module Review
    # Class that manages the available elements for review
    class WeightedExpression
      attr_reader :available_elements, :normal_review, :weight

      # @param [Array<WordMem::DatabaseElement>] available_elements All rows of
      #   the expression database
      # @param [Symbol] review_type Type of review, either :normal or :reverse
      # @param [Integer] weight The value that sets the probability of a random
      #   available element to be returned
      def initialize(available_elements, review_type, weight: 50)
        @available_elements = available_elements
        @normal_review = review_type == :normal
        @weight = weight
      end

      # @return [WordMem::DatabaseElement] Either a random element from
      #   +@available_elements+, or the one with either the lowest number of
      #   reviews, or the lowest score, randomly (again)
      def extract
        random_element_requested? ? random_element : least_reviewed_or_lowest_score
      end

      private

      # @return [String] The expression of the element from
      #   +@available_elements+ with either the lowest number of reviews, or the
      #   lowest score, randomly
      def least_reviewed_or_lowest_score
        [
          least_reviewed_element,
          lowest_score_element
        ].sample.expression
      end

      # @return [WordMem::DatabaseElement] The element from
      #   +@available_elements+ with the lowest number of reviews
      def least_reviewed_element
        available_elements.sort_by! do |element|
          normal_review ? element.reviews_b2t : element.reviews_t2b
        end.first
      end

      # @return [WordMem::DatabaseElement] The element from
      #   +@available_elements+ with the lowest score
      def lowest_score_element
        available_elements.sort_by! do |element|
          normal_review ? element.score_b2t : element.score_t2b
        end.first
      end

      # @return [WordMem::DatabaseElement] A random element from
      #   +@available_elements+
      def random_element
        available_elements[rand(available_elements.length)].expression
      end

      # @return [Boolean] Randomly True or False, depending on
      #   `#probability_array`
      def random_element_requested?
        probability_array.sample
      end

      # @return [Array<Boolean>] The probability array: an array of 100 elements
      def probability_array
        return @probability_array if @probability_array

        @probability_array = []
        weight.times { @probability_array << false }
        (100 - weight).times { @probability_array << true }

        @probability_array
      end
    end
  end
end
