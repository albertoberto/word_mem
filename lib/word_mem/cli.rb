# frozen_string_literal: true

require 'thor'

require_relative 'database'
require_relative 'database_element'
require_relative 'review'

module WordMem
  # Class that models the project's Command Line Interface
  class CLI < Thor
    # Tells Thor to return an unsuccessful return code (different from 0) if
    # an error is raised
    def self.exit_on_failure?
      true
    end

    desc 'review DIRECTION', 'start the review process of the expression database, using direction DIRECTION'
    # Starts the review process of the expression database
    # @param [String] direction Either :b2t (base_language to target_language),
    #   or t2b (target_language to base_language)
    def review(direction = 'b2t')
      direction.to_sym == :b2t ? WordMem::Review::Normal.new.run : WordMem::Review::Reverse.new.run
    end

    desc 'update_tl NEW_LANGUAGE', 'update the target language in the config file to NEW_LANGUAGE'
    # Updates the target language in the config file to +new_language+
    # @param [String] new_language The desired new target language
    def update_tl(new_language)
      config_manager.update_target_language_to(new_language)
    end

    desc 'update_bl NEW_LANGUAGE', 'update the base language in the config file to NEW_LANGUAGE'
    # Updates the base language in the config file to +new_language+
    # @param [String] new_language The desired new base language
    def update_bl(new_language)
      config_manager.update_base_language_to(new_language)
    end

    desc 'reset_db', 'sets reviews and scores of all elements from the database to 0'
    # Sets reviews and scores of all elements from the database to 0
    def reset_db
      db.reset
      db.persist
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

    # @return [WordMem::ConfigManager] Class instance
    def config_manager
      @config_manager ||= WordMem::ConfigManager.new
    end

    # @return [WordMem::Database] Class instance
    def db
      @db ||= WordMem::Database.new
    end
  end
end
