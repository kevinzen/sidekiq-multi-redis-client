# SidekiqMultiRedisClient [![Build Status](https://travis-ci.org/form26/sidekiq-unique-jobs.png?branch=master)](https://travis-ci.org/form26/sidekiq-unique-jobs)

The missing unique jobs for sidekiq

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-multi-redis-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-multi-redis-client

## Usage

All that is required is that you specifically set the sidekiq option for *multi-redis-job* to true like below:

```ruby
sidekiq_options multi-redis-job: true
```

Requiring the gem in your gemfile should be sufficient to enable multi-redis client capability.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

- https://github.com/kevinzen
