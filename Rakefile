#!/usr/bin/env rake

require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'metro_2/version'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default  => :spec

task :build do
  system 'gem build metro_2.gemspec'
end

