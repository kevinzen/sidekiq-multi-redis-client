require 'digest'

module SidekiqMultiRedisClient
  module Middleware
    module Client
      class MultiRedis

        def call(worker_class, item, queue)

          klass = worker_class_constantize(worker_class)
          enabled = klass.get_sidekiq_options['multi_redis_job']

          puts "class = #{klass.nil? ? 'nil' : klass.name}\n"
          puts "enabled = #{enabled ? 'true' : 'false'}\n"

          if enabled

            20.times{

              Sidekiq.configure_client do |config|
                next_redis_config = SidekiqMultiRedisClient::Config.next_redis_connection
                puts next_redis_config
                config.redis = next_redis_config
                puts config.redis { |c| c.client.inspect }
              end

            }
  
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

      end
    end
  end
end
