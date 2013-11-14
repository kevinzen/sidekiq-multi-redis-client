ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'
if ENV.has_key?("SIMPLECOV")
  require 'simplecov'
  SimpleCov.start
end
require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'sidekiq-unique-jobs'
require "sidekiq"
require 'sidekiq/util'
Sidekiq.logger.level = Logger::ERROR

require 'sidekiq/redis_connection'
REDIS = Sidekiq::RedisConnection.create(:url => "redis://localhost/15", :namespace => 'testy')