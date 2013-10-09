require_relative 'registry'

module ChefSpec
  module Stubs
    class CommandRegistry < Registry
      def stub_for(command)
        @stubs.find { |stub| stub.command === command }
      end
    end
  end
end
