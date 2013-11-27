module SidekiqMultiRedisClient
  class Config
    def self.multi_redis_job=(multi_redis_job)
      @multi_redis_job = multi_redis_job
    end

    def self.multi_redis_job
      @multi_redis_job
    end

    # Redises? An Array of redis ConnectionPools
    # 
    def self.redi=(array_of_redis_connection_pools)
      @current_redis = array_of_redis_connection_pools.nil? ? nil : array_of_redis_connection_pools[0]
      @redi = array_of_redis_connection_pools
    end

    def self.redi
      @redi
    end

    def self.current_redis
      @current_redis
    end

    def self.current_redis=(redis_connection_pool)
      @current_redis = redis_connection_pool
    end

    def self.next_redis_connection
      if @redi.size == 1
        return @redi.first
      end
      @current_redis = @redi.reject {|redis_conn| @current_redis == redis_conn}.first
    end

    def self.clear_redi_params
      @current_redis = @redi = nil
    end

    def self.error_count
      @error_count
    end

    def self.inc_error_count
      @error_count = @error_count + 1
    end

    def self.reset_error_count
      @error_count = 0
    end

  end
end
