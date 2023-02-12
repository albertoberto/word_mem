
# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'

task default: %w[yard rubocop test]

desc 'Run RSpec on all *_spec.rb files in spec/'
RSpec::Core::RakeTask.new(:test)

desc 'Run Rubocop on all .rb files in lib/ and spec/'
task :rubocop do
  RuboCop::RakeTask.new do |task|
    task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
    task.fail_on_error = false
  end
end

desc 'Run Yard on all .rb files in lib/'
task :yard do
  YARD::Rake::YardocTask.new { sh 'yard doc --list-undoc' }
end
