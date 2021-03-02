# aws-srp ![Build Status](https://github.com/timfjord/aws-srp/actions/workflows/test.yml/badge.svg)

AWS Cognito SRP Utility

This is a ruby implementation of [the AWS Cognito flow helpers](https://github.com/aws-amplify/amplify-js/blob/main/packages/amazon-cognito-identity-js/src/AuthenticationHelper.js)
using some ideas from [the SIRP gem](https://github.com/grempe/sirp)

By design the `AwsSRP::Flow` only processes params but doesn't trigger any requests.
Requests should be handled on the client side.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-srp'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aws-srp

## Usage

```ruby
flow = AwsSRP::Flow.new
init_params = flow.init_auth

# Do the init AWS Congnito request by sending `init_params`
# Parse the JSON response and pass it to the `AwsSRP::Flow#verify_password`

challenge_request_params = flow.verify_password(challenge_response_body)

# Send the `challenge_request_params` and parse the response.
# The session token should be there
```

## TODO

- Test coverage for `AwsSRP::SRP` and `AwsSRP::Flow` classes
- Handle more AWS Cognito features(2FA, etc)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/timsly/aws-srp.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
