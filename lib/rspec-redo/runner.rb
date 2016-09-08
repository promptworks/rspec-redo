require 'rspec-redo/rake_task'

module RSpecRedo
  class Runner
    class << self
      def invoke(args = ARGV.dup)
        opts = extract!(args)
        new(args, opts).invoke
      end

      private

      def extract!(args)
        {}.tap do |opts|
          if index = args.index('--retry-count')
            opts['retry-count'] = Integer(args.delete_at(index + 1))
            args.delete_at(index)
          end
        end
      rescue ArgumentError
        abort '--retry-count must be an integer'
      end
    end

    attr_accessor :retry_count
    attr_reader :redo_opts, :rspec_opts, :total_retries

    def initialize(rspec_opts, redo_opts = {})
      @rspec_opts = rspec_opts
      @redo_opts = redo_opts
      @total_retries = @retry_count = redo_opts.fetch('retry-count', 1)
    end

    def invoke
      run # Invoke rspec for the first time
      rerun until $?.success? || retry_count.zero?
      abort! unless $?.success?
    end

    private

    def run(args: [], env: ENV)
      system(env, 'rspec', *rspec_opts, *args)
    end

    def rerun
      $stderr.puts "*** Failures occurred. Attempting #{retry_count} more time(s)...\n\n"
      self.retry_count -= 1

      env = ENV.clone.tap { |e| e.store 'RSPEC_REDO', '1' }
      run env: env, args: ['--only-failures']
    end

    def abort!
      abort "Failures still occurred after #{total_retries} retries"
    end
  end
end
