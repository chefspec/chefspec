require_relative 'stub'

module ChefSpec
  module Stubs
    class SearchStub < Stub
      attr_reader :block
      attr_reader :query
      attr_reader :type

      def initialize(type, query = '*:*', &block)
        @type  = type.to_s
        @query = query
        @block = block
      end

      def signature
        if @block
          "stub_search(#{@type.inspect}, #{@query.inspect}) { # Ruby code }"
        else
          "stub_search(#{@type.inspect}, #{@query.inspect}).and_return(#{@value})"
        end
      end
    end
  end
end
