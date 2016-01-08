require 'spec_helper'

RSpec.describe 'Integration', type: :integration do
  let(:pattern) { fixture 'example_spec_fixture.rb' }

  describe 'running the CLI' do
    describe 'a passing spec' do
      let(:example) { 'passes' }

      it 'doesnt output anything to stderr' do
        expect(run[1]).to be_empty
      end

      it 'exists successfully' do
        expect(run[2]).to be_success
      end
    end

    describe 'a failing spec' do
      let(:example) { 'fails' }

      it 'outputs remaining attempts' do
        stderr = run('--retry-count', '2')[1]
        expect(stderr).to match(/Attempting 2 more/)
        expect(stderr).to match(/Attempting 1 more/)
        expect(stderr).to match(/Failures still occurred after 2 retries/)
      end

      it 'exits unsuccessfully' do
        expect(run[2]).not_to be_success
      end
    end
  end

  describe 'running rake' do
    describe 'a passing spec' do
      let(:example) { 'passes' }

      it 'doesnt output anything to stderr' do
        expect(rake[1]).to be_empty
      end

      it 'exists successfully' do
        expect(rake[2]).to be_success
      end
    end

    describe 'a failing spec' do
      let(:example) { 'fails' }

      it 'outputs remaining attempts' do
        stderr = rake(2)[1]
        expect(stderr).to match(/Attempting 2 more/)
        expect(stderr).to match(/Attempting 1 more/)
        expect(stderr).to match(/Failures still occurred after 2 retries/)
      end

      it 'exits unsuccessfully' do
        expect(rake[2]).not_to be_success
      end
    end
  end
end
