#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r arena.rb"
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/arena'
  t.test_files = FileList['test/lib/arena/*_test.rb']
  t.verbose = true
end

task :default => :test
