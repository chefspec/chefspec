require_relative "registry"

module ChefSpec
  module Stubs
    #
    # Registry of shell command stubs declared by the example.
    #
    class CommandRegistry < Registry
      #
      # Find the most recently registered stub matching the given command.
      #
      #
      # @param [String] command
      #   the command the cookbook tried to run
      #
      #
      # @return [ChefSpec::Stubs::Stub, nil]
      #
      def stub_for(command)
        @stubs.find { |stub| stub.command === command }
      end
    end
  end
end
