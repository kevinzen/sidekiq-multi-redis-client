module SidekiqMultiRedisClient
  class Config
    def self.multi_redis_job=(multi_redis_job)
      @multi_redis_job = multi_redis_job
    end

    def self.multi_redis_job
      @multi_redis_job
    end

    # Redises? An Array of redis configuration hashes.
    # For example: { :url => 'redis://redis.example.com:7372/12', :namespace => 'mynamespace' }
    def self.redi=(array_of_redis_config_hashes)
      @current_redis = array_of_redis_config_hashes.nil? ? nil : array_of_redis_config_hashes[0]
      @redi = array_of_redis_config_hashes
    end

    def self.redi
      @redi
    end

    def self.current_redis
      @current_redis
    end

    def self.current_redis=(redis_connection_params)
      @current_redis = redis_connection_params
    end

    def self.next_redis_connection
      @current_redis =  @redi.reject {|redis_conn| @current_redis == redis_conn}.first
    end

    def self.clear_redi_params
      @current_redis = @redi = nil
    end

  end
end
