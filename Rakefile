require 'rubygems'
require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'yard'
task :default => [:install, :spec, :features]

Bundler.setup
Bundler::GemHelper.install_tasks

require 'chef'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty#{' -t ~@requires_chef_10' if Chef::VERSION.start_with? '0.9.'}"
end

RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new