# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sidekiq-multi-redis-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Bedell"]
  gem.email         = ["kbedell@gmail.com"]
  gem.description   = gem.summary = "Allow sidekiq clients to send jobs to multiple redis instances"
  gem.homepage      = "http://kbedell.github.com/sidekiq-multi-redis-client"
  gem.license       = "MIT"

  # gem.executables   = ['']
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "sidekiq-multi-redis-client"
  gem.require_paths = ["lib"]
  gem.version       = SidekiqMultiRedisClient::VERSION
  gem.add_dependency                  'sidekiq', '~> 2.6'
  gem.add_development_dependency      'minitest', '~> 3'
  gem.add_development_dependency      'rake'
  gem.add_development_dependency      'simplecov'
end