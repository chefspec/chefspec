require 'bundler/gem_tasks'
require 'chefspec'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
    a.push('--tag ~chef_11') unless ChefSpec.chef_11?
    a.push('--tag ~chef_10') unless ChefSpec.chef_10?
  end.join(' ')
end

namespace :acceptance do
  ['MiniTest', 'RSpec'].each do |spec_type|
    Cucumber::Rake::Task.new(spec_type.downcase.to_sym, "Run #{spec_type} Cucumber features") do |t|
      t.cucumber_opts = [].tap do |a|
        a.push('CS_SPEC_TYPE=' + spec_type)
        a.push('--color')
        a.push('--format progress')
        a.push('--tags ~@not_implemented_' + spec_type.downcase)
        a.push('--tags ~@chef_11') unless ChefSpec.chef_11?
        a.push('--tags ~@chef_10') unless ChefSpec.chef_10?
      end.join(' ')
    end
  end
end

desc 'Run all Cucumber tests'
task :acceptance => ['acceptance:minitest', 'acceptance:rspec']
