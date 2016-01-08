RSpec.configure do |config|
  file = File.expand_path('../../../tmp/example-failures.txt', __FILE__)
  config.example_status_persistence_file_path = file
end

RSpec.describe 'Passing spec' do
  it 'passes' do
    expect(1).to eq(1)
  end
end

RSpec.describe 'Failing spec' do
  it 'fails' do
    expect(1).to eq(2)
  end
end
