describe 'multi redis middleware' do
    before do
	  mock_redis
      setup_two_redis_conns
    end

    after do
	  #unmock_redis
    end

    it 'changes the redis client for each call' do
		redis_1 = Sidekiq.redis { |c| c.client.location }

	    mw = SidekiqMultiRedisClient::Middleware::Client::MultiRedis.new
		mw.call(MultiRedisJob, nil, nil) { }

		redis_2 = Sidekiq.redis { |c| c.client.location }
		refute_equal redis_1, redis_2
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
