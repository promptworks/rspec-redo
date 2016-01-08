require 'rspec/core/rake_task'

module RSpec::Redo
  class RakeTask < ::RSpec::Core::RakeTask
    RSPEC_REDO_PATH = File.expand_path('../../../../bin/rspec-redo', __FILE__)

    attr_accessor :retry_count

    def initialize(name = 'spec:redo', *args, &block)
      @retry_count = ENV['RETRY_COUNT']

      super(name, :retry_count, *args) do |t, args|
        @retry_count = args.retry_count
        yield self if block_given?
      end
    end

    def rspec_path
      RSPEC_REDO_PATH
    end

    def rspec_opts
      return super unless retry_count
      [*super, '--retry-count', retry_count]
    end

    private

    # @override
    def rspec_load_path
    end
  end
end
