require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'yard/rake/yardoc_task'

require 'chef/version'

YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end

Cucumber::Rake::Task.new(:acceptance) do |t|
  t.cucumber_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
    a.push('--strict')
    a.push('--tags ~@not_chef_' + Chef::VERSION.gsub('.', '_'))
  end.join(' ')
end

desc 'Run all tests'
task :test => [:unit, :acceptance]

task :default => [:test]
