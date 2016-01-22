# RSpec Redo

In RSpec 3.3, the `--only-failures` option was added. This means you can have RSpec dump the failures to a file, and rerun them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-redo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-redo

## Usage

First, you'll need to tell RSpec where to persist a list of failed examples. To do this, you'll have to add a line to your `spec_helper.rb`. You'll want to add this file to your `.gitignore`.

```ruby
RSpec.configure do |c|
  c.example_status_persistence_file_path = 'tmp/rspec-failures.txt'
end
```

Okay, now you're ready. Simply execute:

```shell
$ rspec-redo
```

You can also pass options you'd typically pass to RSpec. For example:

```shell
$ rspec-redo spec/models/person_spec.rb --format doc
```

By default, the program will retry failed specs only once. You can retry multiple times like so:

```shell
$ rspec-redo --retry-count 5
```

## Rake Integration

RSpec Redo includes a build in Rake task generator. To create a new Rake task, add the following to your Rakefile:

```ruby
require 'rspec-redo/rake_task'
RSpecRedo::RakeTask.new 'spec:redo'
```

Cool, now you can run:

```shell
$ rake spec:redo
```

You can customize the command by providing a block:

```ruby
RSpecRedo::RakeTask.new 'spec:redo:models' do |t|
  t.pattern = 'spec/models/*_spec.rb'
end
```

Read [RSpec's documentation](http://www.rubydoc.info/gems/rspec-core/RSpec/Core/RakeTask) for available options.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec_redo.

## Thanks

Inspired by `rspec-rerun`.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
