require 'rubygems'
require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'yard'
task :default => [:install, :spec, :features]

Bundler.setup
Bundler::GemHelper.install_tasks

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

namespace :spec do
  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new('rcov') do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rcov = true
    t.rcov_opts = ['--exclude', 'gems', '--exclude', 'spec/*']
  end
end

RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new