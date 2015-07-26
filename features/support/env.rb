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

  # Use a temporary directory to suppress Travis warnings
  @dirs = [Dir.mktmpdir]
end

After do
  # Cleanup the test files
  FileUtils.rm_rf(@dirs.first)
end
