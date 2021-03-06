require 'digest'

module SidekiqMultiRedisClient
  module Middleware
    module Server
      class MultiRedis
        def call(worker, item, queue)
          yield
        ensure
        end

        protected

        def logger
          Sidekiq.logger
        end

      end
    end
  end
end
