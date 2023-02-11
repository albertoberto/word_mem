# frozen_string_literal: true

require 'thor'

require_relative 'database'

module WordMem
  # Class that models the project's Command Line Interface
  class CLI < Thor
    # Tells Thor to return an unsuccessful return code (different from 0) if
    # an error is raised
    def self.exit_on_failure?
      true
    end

    desc 'add WORD', 'add WORD to the database'
    def add(word)
      db = WordMem::Database.new
      db.append([word, 0, 0, 0])
      db.persist
    end

    desc 'remove WORD', 'remove WORD from the database'
    def remove(word); end
  end
end
