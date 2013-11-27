require 'helper'

class TestFailedConnections < MiniTest::Unit::TestCase
  describe 'with real redis that fails sometimes' do
    before do
    end

    describe "should correctly know when one of the redis conns is bad" do 
      it 'should know there are two redis connections' do
        setup_redis_one_bad
        mw = SidekiqMultiRedisClient::Middleware::Client::MultiRedis.new
        mw.call(MultiRedisJob, nil, nil) { }
      end
    end

  end
end
