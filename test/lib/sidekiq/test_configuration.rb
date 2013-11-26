require 'helper'

class TestConfiguration < MiniTest::Unit::TestCase
  describe 'with real redis' do
    before do
      Sidekiq.redis = REDIS_1
      Sidekiq.redis {|c| c.flushdb }
      Sidekiq.redis = REDIS_2
      Sidekiq.redis {|c| c.flushdb }
    end

    describe "configuration options should be identifiable" do 
      it 'determines if the job is tagged to use multi_redis_job' do
        enabled = MultiRedisJob.get_sidekiq_options['multi_redis_job']
        assert enabled
      end

      it 'determines if the job is tagged to use multi_redis_job' do
        enabled = SingleRedisJob.get_sidekiq_options['multi_redis_job']
        assert !enabled
      end

      it "determines jobs that don't include it arent multi_redis_job" do
        enabled = PlainRedisJob.get_sidekiq_options['multi_redis_job']
        assert !enabled
      end
    end

    describe "figure out how many REDIS endpoints there are" do 
      before "reset" do
        SidekiqMultiRedisClient::Config.redi = nil
      end

      it 'knows when there are no redis instances setup' do
        refute SidekiqMultiRedisClient::Config.redi
      end

      it 'correctly identifies the number of redis instances after setup' do
        setup_two_redis_conns

        redi = SidekiqMultiRedisClient::Config.redi
        assert redi.size, 2
      end

      it 'allows you to set / reset config parameters' do
        setup_two_redis_conns

        redi = SidekiqMultiRedisClient::Config.redi
        assert redi.size, 2

        SidekiqMultiRedisClient::Config.redi = nil
        refute SidekiqMultiRedisClient::Config.redi
      end

      it 'allows you to reset config parameters directly' do
        setup_two_redis_conns

        redi = SidekiqMultiRedisClient::Config.clear_redi_params
        refute SidekiqMultiRedisClient::Config.redi
      end

    end

    describe "configuration options should be identifiable from the string name of the class" do 
      it 'determines if the job is tagged to use multi_redis_job' do
        klass = worker_class_constantize("MultiRedisJob")
        enabled = klass.get_sidekiq_options['multi_redis_job']
        assert enabled
      end

      it 'determines if the job is tagged to use multi_redis_job' do
        klass = worker_class_constantize("PlainRedisJob")
        enabled = klass.get_sidekiq_options['multi_redis_job']
        refute enabled
      end
    end

  end
end
