# frozen_string_literal: true

require 'csv'

require_relative '../word_mem'

module WordMem
  # Class that models the project's Word Database
  class Database
    DB_FILE = File.join(WordMem::PROJECT_ROOT, 'db', 'db.csv').freeze

    def initialize
      validate_db_presence
    end

    def append(line)
      content << line
    end

    def persist
      File.write(DB_FILE, content)
    end

    private

    def content
      @content ||= CSV.read(DB_FILE)
    end

    def validate_db_presence
      return if File.exist?(DB_FILE)

      raise MissingDatabaseError, 'Database `<project_root>/db/db.csv` not found'
    end
  end
end
