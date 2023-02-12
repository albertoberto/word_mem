# frozen_string_literal: true

require 'thor'

require_relative 'database'
require_relative 'database_element'

module WordMem
  # Class that models the project's Command Line Interface
  class CLI < Thor
    # Tells Thor to return an unsuccessful return code (different from 0) if
    # an error is raised
    def self.exit_on_failure?
      true
    end

    desc 'clear_db', 'remove all elements from the database'
    # @see WordMem::Database#clear
    def clear_db
      db.clear
    end

    desc 'add EXPRESSION', 'add EXPRESSION to the database'
    # Appends a row for +expression+ to the project's expression database file
    def add(*expressions)
      expressions.each do |expression|
        next if db.contains?(expression)

        db.append(WordMem::DatabaseElement.new(expression))
      end

      db.persist
    end

    desc 'remove EXPRESSION', 'remove EXPRESSION from the database'
    # Removes the row for +expression+ from the project's expression database
    #  file
    def remove(*expressions)
      expressions.each do |expression|
        next unless db.contains?(expression)

        db.remove(expression)
      end

      db.persist
    end

    private

    # @return [WordMem::Database] Class instance
    def db
      @db ||= WordMem::Database.new
    end
  end
end
