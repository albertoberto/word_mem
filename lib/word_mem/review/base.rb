# frozen_string_literal: true

require 'easy_translate'

require_relative '../config_manager'

module WordMem
  module Review
    # Base class that models the review process of the expression database
    class Base
      # Scores that the user is allowed to give themselves
      ACCEPTABLE_SELF_SCORES = [0, 1, 2, 3, 4].freeze

      # Initializes the class by setting +@continue_review+ to True and setting
      # the google translate API key
      def initialize
        @continue_review = true
        EasyTranslate.api_key = config_manager.retrieve('google_translate_api_key')
      end

      # Runs the review process
      def run
        while @continue_review
          show_expression
          wait_for_user_answer
          show_translation
          score = check_self_evaluation
          update_shown_element_with(score)
          update_avalable_elements
          return if @available_elements.empty?
        end
      end

      private

      # @raise [MissingSpecificImplementation] When the method has not been
      #   overwritten by the corresponding sub-class' method
      def show_expression
        raise MissingSpecificImplementation, 'Missing specific implementation of `WordMem::Review#show_expression`'
      end

      # Waits for the user to be ready to continue the review process after having
      # seen the expression to translate
      def wait_for_user_answer
        print 'Press ENTER to see the translation...'
        require_user_input
      end

      # Shows the translation of +@shown_expression+
      def show_translation
        puts translated_expression
      end

      # Asks the user for a self-evaluation about the translation, and sets
      # +@continue_review+ to false if the score is 0
      # @return [Integer] The self-score, between 0 and 4 (both included)
      def check_self_evaluation
        score = -1
        while unacceptable?(score)
          print 'Score: '
          score = require_user_input.to_i
        end

        puts '---'
        @continue_review = false if score.zero?
        score
      end

      # @param [Integer] _score The self-score to update the shown element with
      # @raise [MissingSpecificImplementation] When the method has not been
      #   overwritten by the corresponding sub-class' method
      def update_shown_element_with(_score)
        raise MissingSpecificImplementation, 'Missing specific implementation of `WordMem::Review#show_expression`'
      end

      # @raise [MissingSpecificImplementation] When the method has not been
      #   overwritten by the corresponding sub-class' method
      def update_avalable_elements
        raise MissingSpecificImplementation, 'Missing specific implementation of `WordMem::Review#show_expression`'
      end

      # Requires the user to enter characters and press the ENTER key
      # @return [String] The user input
      def require_user_input
        $stdin.flush
        $stdin.gets.chomp
      end

      # @raise [MissingSpecificImplementation] When the method has not been
      #   overwritten by the corresponding sub-class' method
      def translated_expression
        raise MissingSpecificImplementation, 'Missing specific implementation of `WordMem::Review#show_expression`'
      end

      # @param [Integer] score The self-score from the user
      # @return [Boolean] False if +score+ has an acceptable value, True otherwise
      def unacceptable?(score)
        !ACCEPTABLE_SELF_SCORES.include?(score)
      end

      # @return [Array<WordMem::DatabaseElement>] All rows of the expression
      #   database
      def available_elements
        @available_elements ||= db.elements
      end

      # @return [WordMem::Database] Class instance
      def db
        @db ||= WordMem::Database.new
      end

      # @return [String] The target language
      def target_language
        @target_language ||= config_manager.target_language
      end

      # @return [String] The base language
      def base_language
        @base_language ||= config_manager.base_language
      end

      # @return [WordMem::ConfigManager] Class instance
      def config_manager
        @config_manager ||= WordMem::ConfigManager.new
      end
    end
  end
end
