require 'open3'
require 'simplecov'
SimpleCov.start

module IntegrationHelpers
  ROOT = File.expand_path('../..', __FILE__)
  EXECUTABLE = File.join(ROOT, 'bin', 'rspec-redo')

  def fixture(filename)
    File.join(ROOT, 'spec', 'fixtures', filename)
  end

  def run(*args)
    Dir.chdir ROOT do
      extras = ['--pattern', pattern, '-e', example]
      Open3.capture3(EXECUTABLE, *args, *extras)
    end
  end

  def rake(retries = nil)
    task = retries ? "fixtures[#{retries}]" : 'fixtures'

    env = ENV.clone.tap do |vars|
      vars['SPEC'] = pattern
      vars['RSPEC_OPTS'] = "-e #{example}"
    end

    Dir.chdir(ROOT) { Open3.capture3(env, 'rake', task) }
  end
end

module StreamHelpers
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
    old_stream.close
  end
end

RSpec.configure do |config|
  config.color = true
  config.include StreamHelpers
  config.include IntegrationHelpers, type: :integration

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
