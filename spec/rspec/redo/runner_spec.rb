require 'spec_helper'
require 'rspec-redo/runner'

module RSpecRedo
  RSpec.describe Runner do
    describe '.invoke' do
      before :each, invoked: true do
        expect_any_instance_of(Runner).to receive(:invoke) { |r| r }
      end

      it 'parses and coerces retry count', :invoked do
        runner = Runner.invoke(['--retry-count', '3'])
        expect(runner.retry_count).to eq(3)
      end

      it 'passes along any extra rspec options', :invoked do
        runner = Runner.invoke(['--retry-count', '2', '-f', 'doc'])
        expect(runner.rspec_opts).to eq(['-f', 'doc'])
      end

      it 'aborts if argument is not an integer' do
        expect {
          silence_stream $stderr do
            Runner.invoke(['--retry-count', 'blah'])
          end
        }.to raise_error(SystemExit, '--retry-count must be an integer')
      end
    end

    describe '#invoke' do
      subject(:runner) { Runner.new([], { 'retry-count' => 2}) }

      it 'exits immediately when successful' do
        expect(runner).to receive(:system).once do
          system 'exit 0'
        end
        expect(runner).not_to receive(:rerun)
        silence_stream($stderr) { runner.invoke }
        expect($?).to be_success
      end

      it 'retries until it hits the max retries' do
        expect(runner).to receive(:system).exactly(3).times do
          system 'exit 1'
        end
        expect(runner).to receive(:abort!)
        silence_stream($stderr) { runner.invoke }
      end

      it 'exits successfully when a rerun is successful' do
        expect(runner).not_to receive(:abort!)
        expect(runner).to receive(:system).once { system 'exit 1' }
        expect(runner).to receive(:system).once { system 'exit 0' }
        silence_stream($stderr) { runner.invoke }
      end

      it 'aborts with an error message' do
        expect(runner).to receive(:system).exactly(3).times do
          system 'exit 1'
        end

        expect {
          silence_stream($stderr) { runner.invoke }
        }.to raise_error(SystemExit, 'Failures still occurred after 2 retries')
      end
    end
  end
end
