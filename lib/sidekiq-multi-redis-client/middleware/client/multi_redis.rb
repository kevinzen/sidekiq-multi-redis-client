require 'digest'

module SidekiqMultiRedisClient
  module Middleware
    module Client
      class MultiRedis
        def call(worker_class, item, queue)

          klass = worker_class_constantize(worker_class)

          enabled = klass.get_sidekiq_options['unique'] || item['unique']

          if enabled

            Sidekiq.redis do |conn|
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

      end
    end
  end
end
