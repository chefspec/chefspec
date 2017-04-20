require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'yard/rake/yardoc_task'
require 'tmpdir'
require 'rspec'
require 'chefspec'

require 'chef/version'

YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end

failed = false

namespace :acceptance do |ns|
  Dir.foreach("examples") do |dir|
    next if dir == '.' or dir == '..'
    desc "#{dir} acceptance tests"
    task dir.to_sym do
      Dir.mktmpdir do |tmp|
        FileUtils.cp_r("examples/#{dir}", tmp)

        pwd = Dir.pwd

        Dir.chdir "#{tmp}/#{dir}" do
          puts "rspec examples/#{dir}"

          #
          # This bit of mildly awful magic below is to load each file into an in-memory
          # RSpec runner while keeping a persistent ChefZero server alive.
          #
          load "#{pwd}/lib/chefspec/rspec.rb"

          RSpec.configure do |config|
            config.color = true
            config.before(:suite) do
              ChefSpec::ZeroServer.setup!
            end
            config.after(:each) do
              ChefSpec::ZeroServer.reset!
            end
          end

          RSpec.clear_examples
          exitstatus = RSpec::Core::Runner.run(["spec"])
          RSpec.reset
          failed = true unless exitstatus == 0
        end
      end
    end
  end
end


task acceptance: Rake.application.tasks.select { |t| t.name.start_with?("acceptance:") } do
  raise "some tests failed" if failed
end

desc 'Run all tests'
task :test => [:unit, :acceptance]

task :default => [:test]
