#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  #SO MUCH NOISE
  #test.warning = true
  test.pattern = 'test/**/test_*.rb'
end

task :default => :test