ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
if ENV.has_key?("SIMPLECOV")
  require 'simplecov'
  SimpleCov.start
end
require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require "sidekiq"
require 'sidekiq/util'
require 'sidekiq/redis_connection'

require 'sidekiq-multi-redis-client'

Sidekiq.logger.level = Logger::ERROR

class MultiRedisJob
  include Sidekiq::Worker
  sidekiq_options :multi_redis_job => true
  def perform(x)
  end
end

class PlainRedisJob
  include Sidekiq::Worker
  def perform(x)
  end
end

class SingleRedisJob
  include Sidekiq::Worker
  sidekiq_options :multi_redis_job => false
  def perform(x)
  end
end

def worker_class_constantize(worker_class)
  if worker_class.is_a?(String)
    worker_class.constantize rescue worker_class
  else
    worker_class
  end
end

def mock_redis
  @redis = Minitest::Mock.new
  def @redis.multi; [yield] * 2 if block_given?; end
  def @redis.set(*); true; end
  def @redis.sadd(*); true; end
  def @redis.srem(*); true; end
  def @redis.get(*); nil; end
  def @redis.del(*); nil; end
  def @redis.incrby(*); nil; end
  def @redis.setex(*); true; end
  def @redis.expire(*); true; end
  def @redis.watch(*); true; end
  def @redis.with_connection; yield self; end
  def @redis.with; yield self; end
  def @redis.exec; true; end
  def @redis.ping; 'PONG'; end
  Sidekiq.instance_variable_set(:@redis, @redis)
end

def unmock_redis
  Sidekiq.instance_variable_set(:@redis, REDIS)
end

#############
#
# Below here setup the redis connections you are testing with. Please don't check in 
# changes to this section. 

# I use these for testing. Change for your situation if needed.
REDIS_1 = Sidekiq::RedisConnection.create(:url => "redis://localhost:6379/15", :namespace => 'testy')
REDIS_2 = Sidekiq::RedisConnection.create(:url => "redis://localhost:6380/15", :namespace => 'testy')

# This one doesn't exist
BAD_REDIS = Sidekiq::RedisConnection.create(:url => "redis://http://10.10.10.1:9999/1", :namespace => 'testy')

REDIS_1_CONNECTION_POOLS = [REDIS_1]
REDIS_2_CONNECTION_POOLS = [REDIS_1, REDIS_2]

REDIS_ONE_BAD = [BAD_REDIS]
REDIS_ONE_GOOD_ONE_BAD = [REDIS_1, BAD_REDIS]

def initialize_redis
  Sidekiq.configure_client do |config|
    next_redis_config = SidekiqMultiRedisClient::Config.next_redis_connection
    config.redis = next_redis_config
  end
end

def setup_one_redis_conn
  SidekiqMultiRedisClient::Config.clear_redi_params
  SidekiqMultiRedisClient::Config.redi = REDIS_1_CONNECTION_POOLS
end

def setup_two_redis_conns
	SidekiqMultiRedisClient::Config.clear_redi_params
	SidekiqMultiRedisClient::Config.redi = REDIS_2_CONNECTION_POOLS
	initialize_redis
end

def setup_redis_one_bad
	SidekiqMultiRedisClient::Config.clear_redi_params
	SidekiqMultiRedisClient::Config.redi = REDIS_ONE_BAD
	initialize_redis
end

def setup_redis_one_good_one_bad
	SidekiqMultiRedisClient::Config.clear_redi_params
	SidekiqMultiRedisClient::Config.redi = REDIS_ONE_GOOD_ONE_BAD
	initialize_redis
end

# Method for flushing redis queues between tests. 
# 'rescue' is needed in case they don't really exist.
def flush_redis_queues (array_of_connection_pools)
	#array_of_connection_pools.each { |redis|  
     # Sidekiq.redis = redis
      #Sidekiq.redis {|c| c.flushdb rescue nil}
  #}
end

