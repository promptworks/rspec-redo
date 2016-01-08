require 'rspec/redo/rake_task'

module RSpec::Redo
  class Runner
    REDO_ARGS = %w(retry-count)

    class << self
      def invoke(args = ARGV)
        parsed = parse(args)
        new(*parsed).invoke
      end

      private

      def parse(args)
        rspec_opts, redo_opts = [], {}
        redo_opts = {}

        args.each.with_index do |arg, i|
          redo_opt_name = REDO_ARGS.find do |pos|
            i > 0 && args[i - 1] == "--#{pos}"
          end

          if redo_opt_name
            redo_opts[redo_opt_name] = arg
          elsif REDO_ARGS.none? { |pos| arg == "--#{pos}" }
            rspec_opts << arg
          end
        end

        [rspec_opts, redo_opts]
      end
    end

    attr_accessor :retry_count
    attr_reader :redo_opts, :rspec_opts, :total_retries

    def initialize(rspec_opts, redo_opts = {})
      @rspec_opts = rspec_opts
      @redo_opts = redo_opts
      @retry_count = redo_opts.fetch('retry-count', 1)
      @total_retries = @retry_count = Integer(@retry_count)
    rescue ArgumentError
      abort '--retry-count must be an integer'
    end

    def invoke
      run # Invoke rspec for the first time
      rerun until $?.success? || retry_count.zero?
      abort! unless $?.success?
    end

    private

    def run(*extra_opts)
      system 'rspec', *rspec_opts, *extra_opts
    end

    def rerun
      $stderr.puts "*** Failures occurred. Attempting #{retry_count} more time(s)...\n\n"
      self.retry_count -= 1
      run '--only-failures'
    end

    def abort!
      abort "Failures still occurred after #{total_retries} retries"
    end
  end
end
