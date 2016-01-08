require 'bundler/gem_tasks'
require 'rspec/redo/rake_task'

# This task is used in integration tests:
RSpec::Redo::RakeTask.new :fixtures do |t|
  t.pattern = 'spec/fixtures/*_spec_fixture.rb'
  t.rspec_opts = ENV['RSPEC_OPTS']
end
