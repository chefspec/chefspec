require 'rspec/core'

# A wrapper class around RSpec for running Aruba::InProcess
module ChefSpec
  class Executor
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end

    def execute!
      exitstatus = RSpec::Core::Runner.run(@argv, @stderr, @stdout)
      @kernel.exit(exitstatus)
    end
  end
end
