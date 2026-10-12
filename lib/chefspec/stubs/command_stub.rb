require_relative "stub"

module ChefSpec
  module Stubs
    #
    # A stubbed shell command, created by +stub_command+.
    #
    class CommandStub < Stub
      attr_reader :block
      attr_reader :command
      attr_reader :value

      def initialize(command, &block)
        @command = command
        @block   = block
      end

      #
      # Set the value the stubbed command returns.
      #
      # @param [Object] value
      #   the value to return
      #
      # @return [self]
      #
      def and_return(value)
        @value = value
        self
      end

      #
      # The value this stub returns, evaluating the block if one was given.
      #
      # @return [Object]
      #
      def result
        if @block
          @block.call
        else
          @value
        end
      end

      #
      # The +stub_command+ call that would register this stub, shown in the
      # "not stubbed" error message.
      #
      # @return [String]
      #
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
