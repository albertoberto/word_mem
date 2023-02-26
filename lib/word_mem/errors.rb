# frozen_string_literal: true

module WordMem
  # Module to group all the project's errors
  module Errors
    # Class that models an error to be raised when the project's expression
    # database is not found
    class MissingDatabase < StandardError; end

    # Class that models an error to be raised when a class' method has not been
    # overwritten by the sub-class' method like it's supposed to
    class MissingSpecificImplementation < StandardError; end

    # Class that models an error to be raised when a an expression in neither
    # base nor target language is being used
    class UnexpectedLanguage < StandardError; end
  end
end
