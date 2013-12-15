require 'aruba'
require 'aruba/cucumber'
require 'aruba/in_process'

require 'rspec'
require 'chefspec'

require_relative 'executor'

Before do
  FileUtils.mkdir_p(current_dir)
  FileUtils.cp_r('examples', current_dir)

  # Use InProcess testing by default
  Aruba::InProcess.main_class = ChefSpec::Executor
  Aruba.process = Aruba::InProcess

  # Need to reload this on each run because RSpec.reset (called by the
  # RSpec::Runner) removes our configurations :(
  load 'lib/chefspec/rspec.rb'

  # Use a temporary directory to suppress Travis warnings
  @dirs = [Dir.mktmpdir]
end

Before('@spawn') do
  Aruba.process = Aruba::SpawnProcess

  # Raise the timeout
  @aruba_timeout_seconds = 15
end

After do
  # Cleanup the test files
  FileUtils.rm_rf(@dirs.first)
end
