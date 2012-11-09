require 'rubygems'
require 'bundler'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'yard'
task :default => [:install, :spec, :features]

Bundler.setup
Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new

require 'chef'

def register_spec_features(spec_type)
  Cucumber::Rake::Task.new(feature_task_name(spec_type),
    "Run Cucumber features (#{spec_type} support only)") do |t|
    t.cucumber_opts = "CS_SPEC_TYPE=#{spec_type} features --format pretty"
    t.cucumber_opts << ' -t ~@requires_chef_10' if Chef::VERSION.start_with? '0.9.'
    t.cucumber_opts << ' -t ~@chefgem' unless defined?(Chef::Resource::ChefGem)
    t.cucumber_opts << " -t ~@not_implemented_#{spec_type.downcase}"
  end
end

def feature_task_name(spec_type)
  "features_#{spec_type.downcase}".to_sym
end

desc "Run all Cucumber features"
task :features
['RSpec', 'MiniTest'].each do |spec_type|
  register_spec_features(spec_type)
  task :features => feature_task_name(spec_type)
end
