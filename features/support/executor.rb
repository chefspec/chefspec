require 'rspec/core'

module ChefSpec
  #
  # @private
  # A wrapper class around RSpec for running Aruba::InProcess
  #
  class Executor
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      exitstatus = RSpec::Core::Runner.run(@argv, @stderr, @stdout)
      @kernel.exit(exitstatus)
    ensure
      RSpec.reset
    end
  end
end
