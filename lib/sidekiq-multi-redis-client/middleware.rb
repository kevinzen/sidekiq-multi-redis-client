require 'sidekiq'

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    require 'sidekiq-multi-redis-client/middleware/client/multi_redis'
    chain.add SidekiqMultiRedisClient::Middleware::Client::MultiRedis
  end

end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    require 'sidekiq-multi-redis-client/middleware/client/multi_redis'
    chain.add SidekiqMultiRedisClient::Middleware::Client::MultiRedis
  end
end
