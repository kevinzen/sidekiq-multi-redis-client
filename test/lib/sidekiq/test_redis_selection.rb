require 'helper'

class TestRedisSelection < MiniTest::Unit::TestCase
  describe 'with real redis' do
    before do
      Sidekiq.redis = REDIS_1
      Sidekiq.redis {|c| c.flushdb }
    end

    describe "should correctly identify different redis connections" do 
	  
      before do
          setup_two_redis_conns
      end

      it 'should know there are two redis connections' do
        assert SidekiqMultiRedisClient::Config.redi.size, 2
      end

      it 'should set the first redis instance as the current one' do
        assert SidekiqMultiRedisClient::Config.current_redis, REDIS_CONNECTIONS[0]
      end

      it "should get the correct values for both of the redis instances" do
        assert SidekiqMultiRedisClient::Config.redi[0], REDIS_CONNECTIONS[0]
        assert SidekiqMultiRedisClient::Config.redi[1], REDIS_CONNECTIONS[1]
      end	

      it "should know when a new redis is fetched that it is the current one " do
      	next_conn = SidekiqMultiRedisClient::Config.next_redis_connection
      	curr_conn = SidekiqMultiRedisClient::Config.current_redis

        assert next_conn, curr_conn
      end	

      it "should get alternately return different ones when asked" do
      	1..100.times do

      	  # do some extras to make sure we're not hitting different boundaries 	
	      (1 + rand(6)).times { SidekiqMultiRedisClient::Config.next_redis_connection }

	      # then grab the next two
	      conn1 = SidekiqMultiRedisClient::Config.next_redis_connection
      	  conn2 = SidekiqMultiRedisClient::Config.next_redis_connection

          # Make sure they are in the array we initialized with
          assert_includes REDIS_CONNECTIONS, conn1
          assert_includes REDIS_CONNECTIONS, conn2

          # Make sure they are different
          refute_equal conn1, conn2
        end
      end	

    end

  end
end
