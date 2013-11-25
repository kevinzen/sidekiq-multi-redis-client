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
  end
