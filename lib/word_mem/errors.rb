# frozen_string_literal: true

module WordMem
  module Errors
    # Class that models an error to be raised when the project's Word Database is not found
    class MissingDatabase < StandardError; end
  end
end
