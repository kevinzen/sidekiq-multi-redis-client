require 'helper'

class TestRedisSelection < MiniTest::Unit::TestCase
  describe 'with real redis' do
    before do
    end


    describe "should correctly work with a single endpoint" do 
    
      before do
          setup_one_redis_conn
      end

      it 'should know there is only one redis connections' do
        assert SidekiqMultiRedisClient::Config.redi.size, 1
      end

      it 'should set the first redis instance as the current one' do
        assert SidekiqMultiRedisClient::Config.current_redis, REDIS_1_CONNECTION_POOLS[0]
      end

      it "should get the correct values for both of the redis instances" do
        assert SidekiqMultiRedisClient::Config.redi[0], REDIS_1_CONNECTION_POOLS[0]
      end 

      it "should know when a new redis is fetched that it is the current one " do
        next_conn = SidekiqMultiRedisClient::Config.next_redis_connection
        curr_conn = SidekiqMultiRedisClient::Config.current_redis

        assert next_conn, curr_conn
      end 

      it "should always return the same redis when asked" do
        1..100.times do

          # do some extras to make sure we're not hitting different boundaries  
          (1 + rand(6)).times { SidekiqMultiRedisClient::Config.next_redis_connection }

          # then grab the next two
          conn1 = SidekiqMultiRedisClient::Config.next_redis_connection
          conn2 = SidekiqMultiRedisClient::Config.next_redis_connection

          # Make sure they are in the array we initialized with
          assert_includes REDIS_1_CONNECTION_POOLS, conn1
          assert_includes REDIS_1_CONNECTION_POOLS, conn2

          # Make sure they are the same
          assert conn1, conn2
        end
      end 

    end

    describe "should correctly identify different redis connections" do 
	  
      before do
          setup_two_redis_conns
      end

      it 'should know there are two redis connections' do
        assert SidekiqMultiRedisClient::Config.redi.size, 2
      end

      it 'should set the first redis instance as the current one' do
        assert SidekiqMultiRedisClient::Config.current_redis, REDIS_2_CONNECTION_POOLS[0]
      end

      it "should get the correct values for both of the redis instances" do
        assert SidekiqMultiRedisClient::Config.redi[0], REDIS_2_CONNECTION_POOLS[0]
        assert SidekiqMultiRedisClient::Config.redi[1], REDIS_2_CONNECTION_POOLS[1]
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
          assert_includes REDIS_2_CONNECTION_POOLS, conn1
          assert_includes REDIS_2_CONNECTION_POOLS, conn2

          # Make sure they are different
          refute_equal conn1, conn2
        end
      end	

    end


  end
end
