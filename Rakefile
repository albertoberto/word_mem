# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: %w[lint spec]

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
  task.fail_on_error = false
end

RSpec::Core::RakeTask.new(:spec)
