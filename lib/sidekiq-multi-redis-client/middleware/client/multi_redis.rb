require 'digest'

module SidekiqMultiRedisClient
  module Middleware
    module Client
      class MultiRedis

        def call(worker_class, item, queue)

          klass = worker_class_constantize(worker_class)
          enabled = klass.get_sidekiq_options['multi_redis_job']

          if enabled 

            point_to_next_redis
            
            if is_redis_conn_there? == false
              point_to_next_redis
            end

            yield 

          else
            yield
          end
        end


        protected

        def worker_class_constantize(worker_class)
          if worker_class.is_a?(String)
            worker_class.constantize rescue worker_class
          else
            worker_class
          end
        end

        def is_redis_conn_there?
          is_there = false
          begin
            Sidekiq.redis do |c| 
              is_there = (c.ping == 'PONG')
            end
          rescue
            # log error
          end
          is_there
        end

        def point_to_next_redis
          Sidekiq.configure_client do |config|
            next_redis_config = SidekiqMultiRedisClient::Config.next_redis_connection
            config.redis = next_redis_config
          end
        end

      end
    end
  end
end
