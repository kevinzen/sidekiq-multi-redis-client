require 'helper'
require 'celluloid'
require 'sidekiq/worker'
require "sidekiq-multi-redis-client"
require 'sidekiq/scheduled'
require 'sidekiq-multi-redis-client/middleware/client/multi-redis'

class TestClient < MiniTest::Unit::TestCase
  describe 'with real redis' do
    before do
      Sidekiq.redis = REDIS
      Sidekiq.redis {|c| c.flushdb }
      QueueWorker.sidekiq_options :multi_redis_job => true
    end

    class QueueWorker
      include Sidekiq::Worker
      sidekiq_options :queue => 'customqueue'
      def perform(x)
      end
    end

    class PlainClass
      def run(x)
      end
    end

    it 'runs the test' do
      assert_equal 1, 1
    end

  end
end
