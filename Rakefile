require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb', 'test/unit/*_test.rb']
end

