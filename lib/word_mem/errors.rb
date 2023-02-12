# frozen_string_literal: true

module WordMem
  # Module to group all the project's errors
  module Errors
    # Class that models an error to be raised when the project's expression
    # database is not found
    class MissingDatabase < StandardError; end
  end
end
