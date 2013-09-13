require_relative 'stub'

module ChefSpec
  module Stubs
    class DataBagStub < Stub
      attr_reader :block
      attr_reader :bag

      def initialize(bag, &block)
        @bag   = bag.to_s
        @block = block
      end

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
