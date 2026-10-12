require_relative "stub"

module ChefSpec
  module Stubs
    #
    # A stubbed data bag, created by +stub_data_bag+.
    #
    class DataBagStub < Stub
      attr_reader :block
      attr_reader :bag

      def initialize(bag, &block)
        @bag   = bag.to_s
        @block = block
      end

      #
      # The +stub_data_bag+ call that would register this stub, shown in the
      # "not stubbed" error message.
      #
      # @return [String]
      #
      def signature
        if @block
          "stub_data_bag(#{@bag.inspect}) { # Ruby code }"
        else
          "stub_data_bag(#{@bag.inspect}).and_return(#{@value})"
        end
      end
    end
  end
end
