# frozen_string_literal: true

module WordMem
  class Error < StandardError
    # Class that models an error to be raised when the project's Word Database is not found
    class MissingDatabaseError < Error
    end
  end
end
