require 'bundler/gem_tasks'
require 'rspec-redo/rake_task'

RSpecRedo::RakeTask.new

desc 'Run fixtures with RSpecRedo (used in integration tests)'
RSpecRedo::RakeTask.new :fixtures do |t|
  t.pattern = 'spec/fixtures/*_spec_fixture.rb'
  t.rspec_opts = ENV['RSPEC_OPTS']
end
