require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

desc "Run tests"
task :default => :test
