# RSpec::Redo

The absolute simplest way to retry flakey specs using built-in RSpec functionality.

In RSpec 3.3, the `--only-failures` option was added. This means you can have RSpec dump the failures to a file, and rerun them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_redo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_redo

## Usage

First, you'll need to tell RSpec where to save the list of failed examples. If you're in a Rails app, `tmp` is probably a good place. Otherwise, just make sure you add the file to your `.gitignore` file.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec_redo.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
