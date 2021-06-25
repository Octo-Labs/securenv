# Securenv

Securely store and set ENV variables via AWS SSM.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'securenv'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install securenv

## Usage

There are two parts to using `securenv`:
1.  Setting secure environment variables in SSM via the command line or programatically.
2.  Populating a runtime ENV with values previously stored in SSM.

### Set a secure environment variable

You can set values via the command line with `securenv set`. (Similar to `heroku config:set`.)

```
securenv set FOO=bar --app myapp --stage production
```

Or you can use the short form:

```
securenv set FOO=bar -a myapp -s production
```

If you want to set them programtically you can do something like this:

```ruby
securenv = Securenv::Client.new(app: 'myapp', stage: 'dev')
securenv.set(variable: 'FOO', value: 'bar')
```

### Using secure environment variables in your app

Before or during the boot stage of your app you can require `securenv` and give it a list of ENV variables
to populate.

```ruby
require 'securenv'

securenv = Securenv::Client.new(
  app: 'myapp', # For rails you could use Rails.application.class.module_parent.name
  stage: ENV['STAGE'] # For rails you might use ENV['RAILS_ENV']
)

securenv.populate_env
```

Then you'll be able to use `ENV['FOO']` (and others) to access the value that you set previously.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/securenv. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/securenv/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Securenv project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/securenv/blob/master/CODE_OF_CONDUCT.md).
