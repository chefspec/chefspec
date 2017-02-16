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

  # These settings need to be reloaded specific to the way Aruba runs. That
  # is why they are here instead of in rspec.rb
  RSpec.configure do |config|
    config.before(:suite) { ChefSpec::ZeroServer.setup! }
    config.after(:each) do
      # We need to reset not only the data but the cookbooks as well
      ChefSpec::ZeroServer.reset!({ clear_cookbooks: true})
    end
  end

  # Use a temporary directory to suppress Travis warnings
  @dirs = [Dir.mktmpdir]
end

After do
  # Cleanup the test files
  FileUtils.rm_rf(@dirs.first)
end
