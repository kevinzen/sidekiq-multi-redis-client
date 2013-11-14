require 'yaml' if RUBY_VERSION.include?('2.0.0')
require 'sidekiq-multi-redis-client/middleware'
require 'sidekiq-multi-redis-client/version'
require 'sidekiq-multi-redis-client/config'

module SidekiqMultiRedisClient
  def self.config
    SidekiqMultiRedisClient::Config
  end
end