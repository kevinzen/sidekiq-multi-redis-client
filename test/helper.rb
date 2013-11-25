ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
if ENV.has_key?("SIMPLECOV")
  require 'simplecov'
  SimpleCov.start
end
require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'sidekiq-multi-redis-client'
require "sidekiq"
require 'sidekiq/util'
Sidekiq.logger.level = Logger::ERROR

require 'sidekiq/redis_connection'
REDIS_1 = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'testy')
REDIS_2 = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'testy')

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

REDIS_CONNECTIONS = [ 
	{ :url => 'redis://localhost:6379/12', :namespace => 'redis1_namespace' },
    { :url => 'redis://localhost:6380/12', :namespace => 'redis2_namespace' } ]



def worker_class_constantize(worker_class)
  if worker_class.is_a?(String)
    worker_class.constantize rescue worker_class
  else
    worker_class
  end
end

def setup_two_redis_conns
	SidekiqMultiRedisClient::Config.redi = REDIS_CONNECTIONS
end
