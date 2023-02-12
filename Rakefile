# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'

task default: %w[lint spec]

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
  task.fail_on_error = false
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run Yard on all .rb files in lib/'
task :yard do
  YARD::Rake::YardocTask.new { sh 'yard doc --list-undoc' }
end
