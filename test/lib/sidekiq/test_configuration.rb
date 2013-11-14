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



  end
end
