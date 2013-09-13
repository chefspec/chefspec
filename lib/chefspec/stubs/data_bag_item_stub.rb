require_relative 'stub'

module ChefSpec
  module Stubs
    class DataBagItemStub < Stub
      attr_reader :block
      attr_reader :id
      attr_reader :bag

      def initialize(bag, id, &block)
        @bag   = bag.to_s
        @id    = id
        @block = block
      end

      def signature
        if @block
          "stub_data_bag_item(#{@bag.inspect}, #{@id.inspect}) { # Ruby code }"
        else
          "stub_data_bag_item(#{@bag.inspect}, #{@id.inspect}).and_return(#{@value})"
        end
      end
    end
  end
end
