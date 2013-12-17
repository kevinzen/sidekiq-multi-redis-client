# SidekiqMultiRedisClient [![Build Status](https://travis-ci.org/kevinzen/sidekiq-multi-redis-client.png?branch=master)](https://travis-ci.org/kevinzen/sidekiq-multi-redis-client)

Enable High Availability by having sidekiq clients submit jobs to more than one redis instance
with different workers. Automatically fail over to one if the other disappears. Spread processing load across all the redis instances.

The initial version of this gem/plugin as it now stands allows (in fact requires) you to specify *TWO* redis instances (each of which will have its own worker(s)).

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

class MultiRedisJob
  include Sidekiq::Worker
  sidekiq_options :multi_redis_job => true  # The client code will now submit jobs to two different redis instances!
  def perform(x)
  end
end

```

Not including the *:multi_redis_job => true* line causes Sidekiq to function as it normally would.

Requiring the gem in your gemfile should be sufficient to enable multi-redis client capability.

## Configuring the two redis endpoints

This gem requires you to specify an ARRAY of redis Connections in your redis initializer, like so:

```
REDIS_1 = Sidekiq::RedisConnection.create(:url => "redis://localhost:6379", :namespace => 'testy')
REDIS_2 = Sidekiq::RedisConnection.create(:url => "redis://localhost:6380", :namespace => 'testy')
REDIS_CONNECTION_POOLS = [REDIS_1, REDIS_2]

SidekiqMultiRedisClient::Config.clear_redi_params
SidekiqMultiRedisClient::Config.redi = REDIS_1_CONNECTION_POOLS
```

This version of the gem requires two redis endpoints and 'round robins' jobs between them. Future versions of this gem will add more flexibility.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

- https://github.com/kevinzen
