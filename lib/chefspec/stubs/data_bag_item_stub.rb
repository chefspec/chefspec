require_relative "stub"

module ChefSpec
  module Stubs
    #
    # A stubbed data bag item, created by +stub_data_bag_item+.
    #
    class DataBagItemStub < Stub
      attr_reader :block
      attr_reader :id
      attr_reader :bag

      def initialize(bag, id, &block)
        @bag   = bag.to_s
        @id    = id
        @block = block
      end

      #
      # The +stub_data_bag_item+ call that would register this stub, shown in the
      # "not stubbed" error message.
      #
      # @return [String]
      #
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
