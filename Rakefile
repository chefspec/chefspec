require 'rubygems'
require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'yard'

task :default => [:install, :features]

Bundler.setup
Bundler::GemHelper.install_tasks

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

YARD::Rake::YardocTask.new