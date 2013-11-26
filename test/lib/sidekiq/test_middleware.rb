describe 'multi redis middleware' do
    before do
      require 'sidekiq-multi-redis-client/middleware/client/multi_redis'
      setup_two_redis_conns
    end

    it 'changes the redis client for each call' do
		redis = Sidekiq.redis { |c| c.client.location }

	    mw = SidekiqMultiRedisClient::Middleware::Client::MultiRedis.new
		mw.call(MultiRedisJob, nil, nil) { }

		new_redis = Sidekiq.redis { |c| c.client.location }
		refute_equal redis, new_redis
    end
    it 'changes the redis client for each call over and over' do
		mw = SidekiqMultiRedisClient::Middleware::Client::MultiRedis.new
		redis_counts = {"localhost:6379" => 0, "localhost:6380" => 0}
    	100.times {
			mw.call(MultiRedisJob, nil, nil) { }
			new_redis = Sidekiq.redis { |c| c.client.location }
			redis_counts[new_redis] = redis_counts[new_redis] + 1
	    }
		assert_equal redis_counts["localhost:6379"], redis_counts["localhost:6380"] 
    end
  end
