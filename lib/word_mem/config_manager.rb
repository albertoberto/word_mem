# frozen_string_literal: true

require 'yaml'

require_relative '../word_mem'

module WordMem
  # Class that manages different configuration parameters needed by the project
  class ConfigManager
    # @param [String] key Name of the key to be retrieved
    # @return [String] The required key
    def retrieve(key)
      keys[key]
    end

    # Updates the target language to +new_language+
    # @param [String] new_language The new target language
    def update_target_language_to(new_language)
      languages = YAML.load_file(languages_file)
      languages['target_language'] = new_language
      File.write(languages_file, languages.to_yaml)
    end

    # Updates the base language to +new_language+
    # @param [String] new_language The new base language
    def update_base_language_to(new_language)
      languages = YAML.load_file(languages_file)
      languages['base_language'] = new_language
      File.write(languages_file, languages.to_yaml)
    end

    # @return [Array<Symbol>] Base and target languages, in this order
    def language_pair
      @language_pair ||= [base_language, target_language]
    end

    # @return [Symbol] The target language
    def target_language
      @target_language ||= languages['target_language'].to_sym
    end

    # @return [Symbol] The base language
    def base_language
      @base_language ||= languages['base_language'].to_sym
    end

    # Updates the randomness value to +new_value+
    # @param [String] new_value The new randomness value
    def update_randomness_to(new_value)
      options = YAML.load_file(general_file)
      options['randomness'] = new_value
      File.write(general_file, options.to_yaml)
    end

    # @return [String] A percentage representing the randomness value with
    #   which shown expressions appear in reviews (i.e., any completely random
    #   one, or some other one according to some specific rule)
    def randomness
      options['randomness']
    end

    private

    # @return [Hash] All options: option name as hash key, option as hash value
    def options
      @options ||= YAML.load_file(general_file)
    end

    # @return [Hash] All keys: key name as hash key, key as hash value
    def keys
      @keys ||= YAML.load_file(keys_file)
    end

    # @return [Hash] All language: target / base language info as hash key,
    #   actual language as hash value
    def languages
      @languages ||= YAML.load_file(languages_file)
    end

    # @return [String] Path to the config file containing general options
    def general_file
      @general_file ||= File.join(WordMem::PROJECT_ROOT, 'config', 'general.yaml')
    end

    # @return [String] Path to the config file containing all keys
    def keys_file
      @keys_file ||= File.join(WordMem::PROJECT_ROOT, 'config', 'keys.yaml')
    end

    # @return [String] Path to the config file containing base and target
    #   languages
    def languages_file
      @languages_file ||= File.join(WordMem::PROJECT_ROOT, 'config', 'languages.yaml')
    end
  end
end
