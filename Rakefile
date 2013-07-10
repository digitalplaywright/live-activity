require "bundler/gem_tasks"
require 'rake'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

task :default => :test

desc 'Generate documentation for the live_stream plugin.'
YARD::Rake::YardocTask.new do |doc|
  doc.files = ['lib/**/*.rb']
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb', 'test/unit/*_test.rb']
end

