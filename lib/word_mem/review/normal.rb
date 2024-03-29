# frozen_string_literal: true

require_relative 'base'

module WordMem
  module Review
    # Class that models the normal review process of the expression database.
    # @note A normal review is one where the word in the target language is shown,
    #   and the user must translate it to the base language
    class Normal < WordMem::Review::Base
      private

      # Shows the user a random expression from the expressions in the expression
      # database that have still not been shown during the review
      def show_expression
        @expression = @db_element.expression
        puts @expression
      end

      # @return [String] The translation of the shown expression
      def show_translation
        @translated_expression = @db_element.translated_expression
        puts @translated_expression
      end

      # Updates the expression database for +@expression+, if the self-score
      # is not 0
      # @param [Integer] score The self-score to update the shown element with
      def update_shown_element_with(score)
        return if score.zero?

        db.increase_review_number_of(@expression, :b2t)
        db.update_score_of(@expression, :b2t, score)
        db.persist
      end

      # Updates the list of elements that can be shown in the next iteration of
      # the review loop
      def update_avalable_elements
        @available_elements -= [
          db.elements.find { |element| element.expression == @expression }
        ]
      end
    end
  end
end
