require 'spec_helper'
require 'rspec/redo/runner'

module RSpec::Redo
  RSpec.describe Runner do
    describe '.invoke' do
      before do
        expect_any_instance_of(Runner).to receive(:invoke) { |r| r }
      end

      it 'parses and coerces retry count' do
        runner = Runner.invoke(['--retry-count', '3'])
        expect(runner.retry_count).to eq(3)
      end

      it 'passes along any extra rspec options' do
        runner = Runner.invoke(['--retry-count', '2', '-f', 'doc'])
        expect(runner.rspec_opts).to eq(['-f', 'doc'])
      end
    end

    describe '#invoke' do
      subject(:runner) { Runner.new([], { 'retry-count' => 2}) }

      it 'exits immediately when successful' do
        expect(runner).to receive(:run).once { system 'exit 0' }
        expect(runner).not_to receive(:rerun)
        runner.invoke
        expect($?).to be_success
      end

      it 'retries until it hits the max retries' do
        expect(runner).to receive(:run).once { system 'exit 1' }
        expect(runner).to receive(:rerun).twice {
          runner.retry_count -= 1 # normal behavior
          system 'exit 1'
        }
        expect(runner).to receive(:abort)
        runner.invoke
      end

      it 'exits successfully when a rerun is successful' do
        expect(runner).to receive(:run).once { system 'exit 1' }
        expect(runner).to receive(:rerun).once { system 'exit 0' }
        runner.invoke
        expect($?).to be_success
      end
    end
  end
end
