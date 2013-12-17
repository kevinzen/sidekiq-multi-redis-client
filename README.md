# SidekiqMultiRedisClient [![Build Status](https://travis-ci.org/kevinzen/sidekiq-multi-redis-client.png?branch=master)](https://travis-ci.org/kevinzen/sidekiq-multi-redis-client)

The use case for this gem is to provide automatic load-balancing and fail-over of jobs submitted to multiple redis instances, each with its own Sidekiq workers. 

In our case, we had two data centers -- each of which needs to be available as backup to the other in case the data center becomes unavailable. This gem allows all jobs to automatically get submitted to the remaining data center if one becomes unavailable -- or even if just one of the redis instances goes away. If one of the redis endpoints goes away, then jobs will be submitted to the other one. 

It also spreads processing across both the redis instances.

The initial version of this gem/plugin as it now stands requires you to specify two redis instances (each of which will have its own worker(s)). The gem then 'round robins' submitting jobs to the two redis instances alternating between them.


NOTE on unit tests failing. While this sentence remains here in the readme, there are failing unit tests because the travis-ci environment does not have any redis instances connected to it for testing. The tests work on my local machine when I have multiple redis instances available. The tests (for now) assume that redis is available. This will be addressed in a future release soon.


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

Not including the ```:multi_redis_job => true``` line causes Sidekiq to function as it normally would.

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
