require_relative 'stub'

module ChefSpec
  module Stubs
    class CommandStub < Stub
      attr_reader :block
      attr_reader :command
      attr_reader :value

      def initialize(command, &block)
        @command = command
        @block   = block
      end

      def and_return(value)
        @value = value
        self
      end

      def result
        if @block
          @block.call
        else
          @value
        end
      end

      def signature
        if @block
          "stub_command(#{@command.inspect}) { # Ruby code }"
        else
          "stub_command(#{@command.inspect}).and_return(#{@value})"
        end
      end
    end
  end
end
