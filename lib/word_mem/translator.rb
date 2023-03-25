# frozen_string_literal: true

require 'easy_translate'

require_relative 'config_manager'

module WordMem
  # Class responsible for translating expressions
  class Translator
    # Initializes the class by setting the Google API key
    def initialize
      EasyTranslate.api_key = config_manager.retrieve('google_translate_api_key')
    end

    # @param [String] expression The expression to be translated
    # @return [String] The translation of +expression+
    def translate(expression)
      EasyTranslate.translate(expression, from: target_language, to: base_language)
    end

    # @param [String] expression The expression whose language is needed
    # @return [Symbol] The language of +expression+
    def language_of(expression)
      EasyTranslate.detect(expression).to_sym
    end

    private

    # @return [Symbol] The target language
    def target_language
      @target_language ||= config_manager.target_language
    end

    # @return [Symbol] The base language
    def base_language
      @base_language ||= config_manager.base_language
    end

    # @return [WordMem::ConfigManager] Class instance
    def config_manager
      @config_manager ||= WordMem::ConfigManager.new
    end
  end
end
