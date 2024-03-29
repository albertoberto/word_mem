# frozen_string_literal: true

require 'csv'

require_relative 'errors'
require_relative '../word_mem'

module WordMem
  # Class that models the project's expression database
  # @example The content of the expression database file (an array of arrays)
  #   [
  #      ['word', 0, 0, 0, 0],
  #      ['a sentence', 1, 0, 4, 0],
  #      ['another word', 2, 1, 4, 1]
  #   ]
  # @example The content of this class' +@elements+ variable (an array of WordMem::DatabaseElement)
  #   [
  #      <WordMem::DatabaseElement @expression='word', @reviews_b2t='0',  ... <and so on> ... >,
  #      <WordMem::DatabaseElement @expression='a sentence', @reviews_b2t="0", ... <and so on> ... >,
  #      <WordMem::DatabaseElement @expression='another word', @reviews_b2t=0, ... <and so on> ... >]
  #   ]
  class Database
    # The absolute path to the project's expression database
    DB_FILE = File.join(WordMem::PROJECT_ROOT, 'config', 'db.csv').freeze

    # @see WordMem::Database#validate_db_presence
    def initialize
      validate_db_presence
    end

    # Appends +db_element+ to the +@elements+ array
    # @param [WordMem::DatabaseElement] db_element The element to be appended
    def append(db_element)
      elements << db_element
    end

    # Removes the row for +expression+ from the expression database
    # @param [String] expression The expression to be remvoed
    def remove(expression)
      elements.reject! { |db_element| db_element.expression == expression }
    end

    # Increases the review number of +expression+ by +amount+
    # @param [String] expression The expression whose review number increases
    # @param [Symbol] direction direction Either :b2t (base_language to target_language),
    #   or t2b (target_language to base_language)
    # @param [Integer] amount The amount by which the review number increases
    def increase_review_number_of(expression, direction, amount = 1)
      if direction == :b2t
        element = elements.find { |elem| elem.expression == expression }
        element.reviews_b2t = new_b2t_review_number_of(element, amount)
      else
        element = elements.find { |elem| elem.translated_expression == expression }
        element.reviews_t2b = new_t2b_review_number_of(element, amount)
      end
    end

    # Updates the score of +expression+ by +new_score+
    # @param [String] expression The expression whose review number increases
    # @param [Symbol] direction direction Either :b2t (base_language to target_language),
    #   or t2b (target_language to base_language)
    # @param [Integer] new_score The latest score, used to update the
    #   expression's score
    def update_score_of(expression, direction, new_score)
      if direction == :b2t
        element = elements.find { |elem| elem.expression == expression }
        element.score_b2t = new_score_b2t_of(element, new_score)
      else
        element = elements.find { |elem| elem.translated_expression == expression }
        element.score_t2b = new_score_t2b_of(element, new_score)
      end
    end

    # @param [String] expression The expression to be removed
    # @return [Boolean] True if the expression database containes +expression+,
    #   False otherwise
    def contains?(expression)
      expressions.include?(expression)
    end

    # @return [Array<WordMem::DatabaseElement>] All rows of the expression
    #   database
    def elements
      return @elements if @elements

      @elements = []
      CSV.foreach(DB_FILE) do |db_element|
        @elements << WordMem::DatabaseElement.new(
          expression: db_element[0],
          translated_expression: db_element[1],
          reviews_b2t: db_element[2],
          reviews_t2b: db_element[3],
          score_b2t: db_element[4],
          score_t2b: db_element[5]
        )
      end

      @elements
    end

    # Sets reviews and scores of all elements in +@elements+ to 0
    def reset
      elements.each do |element|
        element.reviews_b2t = 0
        element.reviews_t2b = 0
        element.score_b2t = 0
        element.score_t2b = 0
      end
    end

    # Removes all elements from the project's expression database .csv file
    def clear
      CSV.open(DB_FILE, 'w') { |csv| csv }
    end

    # Saves the +@elements+ array in the project's expression database .csv file
    def persist
      CSV.open(DB_FILE, 'w') do |csv|
        elements.each { |db_element| csv << db_element.to_array }
      end
    end

    # @param [String] expression The expression to be translated
    # @param [Boolean] b2t True if the translation is from base to target
    #  language, false otherwise
    # @return [String] The translation of the passed +expression+
    def translation_of(expression, b2t:)
      if b2t
        elements.find { |elem| elem.expression == expression }.translated_expression
      else
        elements.find { |elem| elem.translated_expression == expression }.expression
      end
    end

    private

    # @param [String] element The database element whose review number increases
    # @param [Integer] amount The amount of reviews to increase the number with
    # @return [String] The new b2t review number of +element+, given +amount+
    def new_b2t_review_number_of(element, amount)
      (element.reviews_b2t.to_i + amount).to_s
    end

    # @param [String] element The database element whose review number increases
    # @param [Integer] amount The amount of reviews to increase the number with
    # @return [String] The new t2b review number of +element+, given +amount+
    def new_t2b_review_number_of(element, amount)
      (element.reviews_t2b.to_i + amount).to_s
    end

    # @param [String] element The element whose review number increases
    # @param [Integer] new_score The latest score, used to update the
    #   element's score
    # @return [String] The new b2t score of +element+, given +new_score+
    def new_score_b2t_of(element, new_score)
      old_cumulative_score = (element.score_b2t.to_f * (element.reviews_b2t.to_f - 1))
      updated_cumulative_score = (old_cumulative_score + new_score).to_f
      (updated_cumulative_score / element.reviews_b2t.to_f).round(2).to_s
    end

    # @param [String] element The element whose review number increases
    # @param [Integer] new_score The latest score, used to update the
    #   element's score
    # @return [String] The new t2b score of +element+, given +new_score+
    def new_score_t2b_of(element, new_score)
      old_cumulative_score = (element.score_t2b.to_f * (element.reviews_t2b.to_f - 1))
      updated_cumulative_score = (old_cumulative_score + new_score).to_f
      (updated_cumulative_score / element.reviews_t2b.to_f).round(2).to_s
    end

    # @return [Array<String>] All expressions of the expression database
    # @example: ['word', 'a sentence', 'another word']
    def expressions
      @expressions ||= elements.empty? ? [] : elements.map(&:expression)
    end

    # @return [nil] If the project's expression database file is at
    #   <project_root>/db/ and is called `db.csv`
    # @raise [WordMem::Errors::MissingDatabase] If the database is not where
    #   it's supposed to be
    def validate_db_presence
      return if File.exist?(DB_FILE)

      raise WordMem::Errors::MissingDatabase, 'Database `<project_root>/db/db.csv` not found'
    end
  end
end
