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
      @redi = array_of_redis_config_hashes
    end

    def self.redi
      @redi
    end

    def self.clear_redi_params
      @redi = nil
    end

  end
end
