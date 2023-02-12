# frozen_string_literal: true

require 'csv'

require_relative 'errors'
require_relative '../word_mem'

module WordMem
  # Class that models the project's Word Database
  class Database
    DB_FILE = File.join(WordMem::PROJECT_ROOT, 'db', 'db.csv').freeze

    def initialize
      validate_db_presence
    end

    def append(db_element)
      elements << db_element
    end

    def remove(expression)
      elements.reject! { |db_element| db_element.first == expression }
    end

    def contains?(expression)
      expressions.include?(expression)
    end

    def clear
      CSV.open(DB_FILE, 'w') { |csv| csv }
    end

    def persist
      CSV.open(DB_FILE, 'w') do |csv|
        elements.each { |db_element| csv << db_element }
      end
    end

    private

    def expressions
      @expressions ||= elements.empty? ? [] : elements.map(&:first)
    end

    def elements
      return @elements if @elements

      @elements = []
      CSV.foreach(DB_FILE) { |db_element| @elements << db_element }
      @elements
    end

    def validate_db_presence
      return if File.exist?(DB_FILE)

      raise WordMem::Errors::MissingDatabase, 'Database `<project_root>/db/db.csv` not found'
    end
  end
end
