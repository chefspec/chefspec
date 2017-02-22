require 'aruba'
require 'aruba/cucumber'
require 'aruba/in_process'

require 'rspec'
require 'chefspec'

require_relative 'executor'

Before do
  FileUtils.mkdir_p(expand_path('.'))

  # Use InProcess testing by default
  Aruba.configure do |config|
    config.command_launcher = :in_process
    config.main_class = ChefSpec::Executor
  end

  # Need to reload this on each run because RSpec.reset (called by the
  # RSpec::Runner) removes our configurations :(
  load 'lib/chefspec/rspec.rb'

  # These settings need to be specified manually here rather than in rspec.rb
  # because we do not want the zero-server terminating between each run. The
  # runs happen too quickly in succession the port doesn't have time to get reset.
  RSpec.configure do |config|
    config.before(:suite) { ChefSpec::ZeroServer.setup! }
    config.after(:each) { ChefSpec::ZeroServer.reset! }
  end

  # Use a temporary directory to suppress Travis warnings
  @dirs = [Dir.mktmpdir]
end

After do
  # Cleanup the test files
  FileUtils.rm_rf(@dirs.first)
end
