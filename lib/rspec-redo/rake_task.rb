require 'rspec/core/rake_task'

module RSpecRedo
  class RakeTask < ::RSpec::Core::RakeTask
    RSPEC_REDO_PATH = File.expand_path('../../../bin/rspec-redo', __FILE__)

    attr_accessor :retry_count

    def initialize(name = 'spec:redo', *args, &block)
      @retry_count = ENV['RETRY_COUNT']

      unless ::Rake.application.last_comment
        desc 'Run RSpec code examples with RSpecRedo'
      end

      super(name, :retry_count, *args) do |t, args|
        @retry_count = args.retry_count
        yield self if block_given?
      end
    end

    # @override
    # Swap out RSpec for the Redo CLI
    def rspec_path
      RSPEC_REDO_PATH
    end

    # @override
    # Include the retry_count if it's provided
    def rspec_opts
      return super unless retry_count
      [*super, '--retry-count', retry_count]
    end

    private

    # @override
    # We don't need to require rspec libs for this command
    def rspec_load_path
    end
  end
end
