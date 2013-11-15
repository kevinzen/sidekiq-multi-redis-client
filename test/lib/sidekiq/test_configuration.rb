require 'helper'
require 'celluloid'
require 'sidekiq/worker'
require "sidekiq-multi-redis-client"
require 'sidekiq/scheduled'
require 'sidekiq-multi-redis-client/middleware/client/multi_redis'

class TestConfiguration < MiniTest::Unit::TestCase
  describe 'with real redis' do
    before do
      Sidekiq.redis = REDIS_1
      Sidekiq.redis {|c| c.flushdb }
    end

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

    describe "configuration options should be identifiable" do 
      it 'determines if the job is tagged to use multi_redis_job' do
        enabled = MultiRedisJob.get_sidekiq_options['multi_redis_job']
        assert enabled
      end

      it 'determines if the job is tagged to use multi_redis_job' do
        enabled = SingleRedisJob.get_sidekiq_options['multi_redis_job']
        assert !enabled
      end

      it "determines jobs that don't include it arent multi_redis_job" do
        enabled = PlainRedisJob.get_sidekiq_options['multi_redis_job']
        assert !enabled
      end
    end

    describe "figure out how many REDIS endpoints there are" do 
      before "reset" do
        SidekiqMultiRedisClient::Config.redi = nil
      end

      it 'knows when there are no redis instances setup' do
        refute SidekiqMultiRedisClient::Config.redi
      end

      it 'correctly identifies the number of redis instances after setup' do
        redis1 = { :url => 'redis://localhost:6379/12', :namespace => 'redis1_namespace' }
        redis2 = { :url => 'redis://localhost:6380/12', :namespace => 'redis2_namespace' }
        redi = [redis1, redis2]
        SidekiqMultiRedisClient::Config.redi = redi

        redi = SidekiqMultiRedisClient::Config.redi
        assert redi.size, 2
      end

      it 'allows you to set / reset config parameters' do
        redis1 = { :url => 'redis://localhost:6379/12', :namespace => 'redis1_namespace' }
        redis2 = { :url => 'redis://localhost:6380/12', :namespace => 'redis2_namespace' }
        redi = [redis1, redis2]
        SidekiqMultiRedisClient::Config.redi = redi

        redi = SidekiqMultiRedisClient::Config.redi
        assert redi.size, 2

        SidekiqMultiRedisClient::Config.redi = nil
        refute SidekiqMultiRedisClient::Config.redi
      end

      it 'allows you to reset config parameters directly' do
        redis1 = { :url => 'redis://localhost:6379/12', :namespace => 'redis1_namespace' }
        redis2 = { :url => 'redis://localhost:6380/12', :namespace => 'redis2_namespace' }
        redi = [redis1, redis2]
        SidekiqMultiRedisClient::Config.redi = redi

        redi = SidekiqMultiRedisClient::Config.clear_redi_params
        refute SidekiqMultiRedisClient::Config.redi
      end

    end

  end
end
