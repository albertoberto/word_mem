# frozen_string_literal: true

require 'csv'

require_relative 'errors'
require_relative '../word_mem'

module WordMem
  # Class that models the project's expression database
  class Database
    # The absolute path to the project's expression database
    DB_FILE = File.join(WordMem::PROJECT_ROOT, 'db', 'db.csv').freeze

    # @see WordMem::Database#validate_db_presence
    def initialize
      validate_db_presence
    end

    # Appends +db_element+ to the +@elements+ array
    # @param [Array] db_element The row to be appended
    def append(db_element)
      elements << db_element
    end

    # Removes the row for +expression+ from the expression database
    # @param [String] expression The expression to be remvoed
    def remove(expression)
      elements.reject! { |db_element| db_element.first == expression }
    end

    # @param [String] expression The expression to be removed
    # @return [Boolean] True if the expression database containes +expression+,
    #   False otherwise
    def contains?(expression)
      expressions.include?(expression)
    end

    # Removes all elements from the project's expression database .csv file
    def clear
      CSV.open(DB_FILE, 'w') { |csv| csv }
    end

    # Saves the +@elements+ array in the project's expression database .csv file
    def persist
      CSV.open(DB_FILE, 'w') do |csv|
        elements.each { |db_element| csv << db_element }
      end
    end

    private

    # @return [Array<String>] All expressions of the expression database
    # @example: ['word', 'a sentence', 'another word']
    def expressions
      @expressions ||= elements.empty? ? [] : elements.map(&:first)
    end

    # @return [Array<Array>] All rows of the expression database
    # @example
    #   [
    #      ['word', 0, 0, 0, 0],
    #      ['a sentence', 1, 0, 4, 0],
    #      ['another word', 2, 1, 4, 1]
    #   ]
    def elements
      return @elements if @elements

      @elements = []
      CSV.foreach(DB_FILE) { |db_element| @elements << db_element }
      @elements
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
