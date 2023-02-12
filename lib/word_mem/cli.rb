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
    def clear_db
      db.clear
    end

    desc 'add EXPRESSION', 'add EXPRESSION to the database'
    def add(expression)
      return if db.contains?(expression)

      db.append(WordMem::DatabaseElement.new(expression).to_row)
      db.persist
    end

    desc 'remove EXPRESSION', 'remove EXPRESSION from the database'
    def remove(expression)
      return unless db.contains?(expression)

      db.remove(expression)
      db.persist
    end

    private

    def db
      @db ||= WordMem::Database.new
    end
  end
end
